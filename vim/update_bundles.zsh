#!/bin/bash

# Idea from http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen/ but didn't want to require ruby

FORCE_UPDATE_SCRIPTS=0
BUNDLES_DIR="${DOTFILES}/vim.symlink/bundle"
GIT_BUNDLES=(
	'https://github.com/mileszs/ack.vim.git'
	'https://github.com/rking/ag.vim'
	'https://github.com/gregsexton/gitv'
	'https://github.com/Yggdroot/indentLine'
	'git://github.com/msanders/snipmate.vim.git'
	'https://github.com/scrooloose/syntastic.git'
	'https://github.com/vim-scripts/TaskList.vim'
	'git://github.com/tpope/vim-endwise.git'
	'https://github.com/chrisbra/vim-diff-enhanced.git'
	'git://github.com/tpope/vim-fugitive.git'
	'https://github.com/elzr/vim-json'
	'https://github.com/vim-pandoc/vim-pandoc.git'
	'https://github.com/vim-pandoc/vim-pandoc-syntax.git'
	'git://github.com/tpope/vim-surround.git'
	'https://github.com/sukima/xmledit'
)
# 'IndexedSearch 7062 plugin'
VIM_ORG_SCRIPTS=(
)

if test ! -e "${BUNDLES_DIR}"; then
	mkdir -p "${BUNDLES_DIR}"
fi

for gitBundle in "${GIT_BUNDLES[@]}"; do
	bundleName=$(echo "${gitBundle}" |awk -F '/' '{print $NF}' | sed 's/.git$//g')
	if -d "${BUNDLES_DIR}/${bundleName}"; then
		git -C "${BUNDLES_DIR}/${bundleName}" pull
	else
		git clone "${gitBundle}" "${BUNDLES_DIR}/${bundleName}"
	fi
done

for vimOrgScript in "${VIM_ORG_SCRIPTS[@]}"; do
	read -a -r scriptNameIdType <<< "${vimOrgScript}"
	scriptName=${scriptNameIdType[0]}
	scriptId=${scriptNameIdType[1]}
	scriptType=${scriptNameIdType[2]}
	if test ! -f "${BUNDLES_DIR}/${scriptName}/${scriptType}/${scriptName}.vim" -o ${FORCE_UPDATE_SCRIPTS} -eq 1; then
		mkdir -p "${BUNDLES_DIR}/${scriptName}/${scriptType}"
		curl "http://www.vim.org/scripts/download_script.php?src_id=${scriptId}" -o "${BUNDLES_DIR}/${scriptName}/${scriptType}/${scriptName}.vim"
	fi
done
