#!/bin/sh

set -xe

RUBY_VERSION=$(grep '^Version: ' ruby-${1}.spec | awk '{ print $NF }')

need_to_release() {
	http_code=$(curl -sL -w "%{http_code}\\n" https://github.com/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/releases/tag/${RUBY_VERSION} -o /dev/null)
	test $http_code = "404"
}

get_github_release() {
  version=v0.10.0
  wget https://github.com/github-release/github-release/releases/download/${version}/linux-amd64-github-release.bz2
  bzip2 -d linux-amd64-github-release.bz2
  chmod +x linux-amd64-github-release
  mkdir -p $HOME/bin
  mv linux-amd64-github-release $HOME/bin/github-release
}

if ! need_to_release; then
	echo "$CIRCLE_PROJECT_REPONAME $RUBY_VERSION has already released."
	exit 0
fi

get_github_release
cp $CIRCLE_ARTIFACTS/*.rpm .

#
# Create a release page
#

$HOME/bin/github-release release \
  --user $CIRCLE_PROJECT_USERNAME \
  --repo $CIRCLE_PROJECT_REPONAME \
  --tag $RUBY_VERSION \
  --name "Ruby-${RUBY_VERSION}" \
  --description "not release" \
  --target master

#
# Upload rpm files and build a release note
#

print_rpm_markdown() {
  RPM_FILE=$1
  cat <<EOS
* $RPM_FILE
    * sha256: $(openssl sha256 $RPM_FILE | awk '{print $2}')
EOS
}

upload_rpm() {
  RPM_FILE=$1
  $HOME/bin/github-release upload --user $CIRCLE_PROJECT_USERNAME \
    --repo $CIRCLE_PROJECT_REPONAME \
    --tag $RUBY_VERSION \
    --name "$RPM_FILE" \
    --file $RPM_FILE
}

cat <<EOS > description.md
Use at your own risk!

Build on CentOS 7

EOS

# CentOS 7
for i in *.el7.centos.*.rpm; do
  print_rpm_markdown $i >> description.md
  upload_rpm $i
done

#
# Make the release note to complete!
#

$HOME/bin/github-release edit \
  --user $CIRCLE_PROJECT_USERNAME \
  --repo $CIRCLE_PROJECT_REPONAME \
  --tag $RUBY_VERSION \
  --name "Ruby-${RUBY_VERSION}" \
  --description "$(cat description.md)"
