#!/usr/bin/env bash

# set -euo pipefail

OWNER=WhatsApp
REPO=erlang-language-platform
GH_REPO="https://github.com/${OWNER}/${REPO}"
TOOL_NAME="elp"
TOOL_TEST="elp -h"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if elp is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
	# find OTP versions for each tag:
	releases=$(curl -s "https://api.github.com/repos/${OWNER}/${REPO}/releases" | jq -c '.[]')
	os=$(get_os | awk '{print $1}')
	arch=$(get_arch)

	if [[ -n "$releases" ]]; then
		while IFS=$'\n' read -r release; do
			tag=$(echo -E "$release" | jq -r '.tag_name')
			assets=$(echo -E "$release" | jq -r '.assets[].name')

			if [[ -n "$assets" ]]; then
				while IFS= read -r asset; do
					if [[ -n "$asset" ]]; then
						if [[ "$asset" == *"$os-$arch"*".tar.gz" ]]; then
							otp_version=$(echo "$asset" | sed -E 's/.*(otp-[0-9]+(\.[0-9]+)?).*/\1/')
							if [[ -n "$otp_version" ]]; then
								echo "${tag}_${otp_version}"
							fi
						fi
					fi
				done <<<"$assets"
			else
				echo "No assets found for tag: $tag" >&2
			fi
		done <<<"$releases"
	else
		echo "No releases found for repository: ${OWNER}/${REPO}" >&2
	fi
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	tag=$(echo "$version" | sed 's/_/ /' | awk '{print $1}')
	otp=$(echo "$version" | sed 's/_/ /' | awk '{print $2}')
	os_1=$(get_os | awk '{print $1}')
	os_2=$(get_os | awk '{print $2}')
	arch=$(get_arch)

	url="$GH_REPO/releases/download/${tag}/elp-$os_1-$arch-$os_2-$otp.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

get_os() {
	local os
	os="$(uname -s)"

	case $os in
	Darwin)
		echo "macos apple-darwin"
		;;
	Linux)
		echo "linux unknown-linux-gnu"
		;;
	*)
		echo "$os"
		;;
	esac
}

get_arch() {
	local arch
	arch="$(uname -m)"

	case $arch in
	x86_64)
		echo amd64
		;;
	arm64)
		echo aarch64
		;;
	*)
		echo "$arch"
		;;
	esac
}
