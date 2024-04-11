#!/bin_zsh
function DockerStart() {
  #docker-compose -f docker-compose-no-app-for-m1.yml up --build
  echo "on the way to ..."
}

function Gcp() {
  git branch -a --sort=-authordate |
    grep -v -e '->' -e '*' |
    perl -pe 's/^\h+//g' |
    perl -pe 's#^remotes/origin/##' |
    perl -nle 'print if !$c{$_}++' |
    peco |
    xargs git checkout
}

function RailsTest() {
	local file=$(gs | grep 'spec/' | sed 's/.*spec\//spec\//' | peco)

	# ファイルが選択されなかった場合、処理を終了
	if [ -z "$file" ]; then
			echo "ファイルが選択されませんでした。"
			return 1
	fi

	# 選択されたファイルのテストケース（ファイル名:行数）をリストアップし、それを `peco` で選択
	local testcase=$(grep -n 'it ' "$file" | peco | awk -F ':' '{print $1}')

	# テストケースが選択されなかった場合、処理を終了
	if [ -z "$testcase" ]; then
		RAILS_ENV=test bundle exec rspec "${file}"
	else
		# RSpecを選択されたファイルとテストケースで実行
		RAILS_ENV=test bundle exec rspec "${file}:${testcase}"
	fi
}
