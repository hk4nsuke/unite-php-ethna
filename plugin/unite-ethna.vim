" ethna-jump.vim:
" Load Once:
if &cp || exists("g:loaded_unite_ethna")
    finish
endif
let g:loaded_unite_ethna = 1
let s:keepcpo = &cpo
set cpo&vim
" ---------------------------------------------------------------------

let s:backends = ['GenericDao', 'TdGateway', 'Module']
let s:frontends = ['act', 'view']
let s:templates = ['tpl']

function! s:FullPath()
    return expand('%:p')
endfunction

function! s:IsBackEnd()
    for b in s:backends
        if (matchstr(s:FullPath(), '/' . b . '/\(.\{-\}/\)\{-\}.\{-\}\.php\?$') != '')
            return b
        endif
    endfor
    return ''
endfunction

function! s:GetBackEndPathList(keyword)
    let l:pre  = substitute(s:FullPath(), '^\(.*\)/' . a:keyword . '/\(\(.\{-\}/\)*.\{-\}\.php\)$', '\1', '')
    let l:post = substitute(s:FullPath(), '^\(.*\)/' . a:keyword . '/\(\(.\{-\}/\)*.\{-\}\.php\)$', '\2', '')

    let l:list = []
    for b in s:backends
        " ファイルが存在する場合 QuickFix Window に追加
        let l:filename = l:pre . '/' . b . '/' . l:post
        if (glob(l:filename) != '')
            call add(l:list, {'filename': l:filename})
        endif
    endfor

    return l:list
endfunction

function! s:IsFrontEnd()
    for f in s:frontends
        if (matchstr(s:FullPath(), '/' . f . '/\(.\{-\}/\)\{-\}.\{-\}\.php\?$') != '')
            return f
        endif
    endfor
    return ''
endfunction

function! s:IsTemplate()
    for f in s:templates
        if (matchstr(s:FullPath(), '/' . f . '/\(.\{-\}/\)\{-\}.\{-\}\.tpl$') != '')
            return f
        endif
    endfor
    return ''
endfunction

function! s:GetFronEndPathListFromFrontEnd(keyword)
    let l:pre  = substitute(s:FullPath(), '^\(.*\)/' . a:keyword . '/\(\(.\{-\}/\)*.\{-\}\.php\)$', '\1', '')
    let l:post = substitute(s:FullPath(), '^\(.*\)/' . a:keyword . '/\(\(.\{-\}/\)*.\{-\}\.php\)$', '\2', '')

    let l:list = []
    for b in s:frontends
        " ファイルが存在する場合 QuickFix Window に追加
        let l:filename = l:pre . '/' . b . '/' . l:post
        if (glob(l:filename) != '')
            call add(l:list, {'filename': l:filename})
        endif
    endfor

    let l:tpl_post = substitute(l:post, '\(^.*\)\.php\?$', '\L\1.tpl', '')
    for b in s:templates
        " ファイルが存在する場合 QuickFix Window に追加
        let l:filename = l:pre . '/' . b . '/' . l:tpl_post
        if (glob(l:filename) != '')
            call add(l:list, {'filename': l:filename})
        endif
    endfor

    return l:list
endfunction

function! s:GetFronEndPathListFromTemplate(keyword)
    let l:pre  = substitute(s:FullPath(), '^\(.*\)/' . a:keyword . '/\(\(.\{-\}/\)*.\{-\}\.tpl\)$', '\1', '')
    let l:post = substitute(s:FullPath(), '^\(.*\)/' . a:keyword . '/\(\(.\{-\}/\)*.\{-\}\.tpl\)$', '\2', '')

    let l:list = []

    " todo; php? format に未対応
    let l:frontend_post = substitute(l:post, '\(^.\)', '\U\1', 'g')
    let l:frontend_post = substitute(l:frontend_post, '/\(.\)', '/\U\1', 'g')
    let l:frontend_post = substitute(l:frontend_post, '\.tpl$', '.php', '')
    for b in s:frontends
        " ファイルが存在する場合 QuickFix Window に追加
        let l:filename = l:pre . '/' . b . '/' . l:frontend_post
        if (glob(l:filename) != '')
            call add(l:list, {'filename': l:filename})
        endif
    endfor

    for b in s:templates
        " ファイルが存在する場合 QuickFix Window に追加
        let l:filename = l:pre . '/' . b . '/' . l:post
        if (glob(l:filename) != '')
            call add(l:list, {'filename': l:filename})
        endif
    endfor

    return l:list
endfunction

function! UniteEthnaGetList()
    let l:keyword = s:IsBackEnd()
    if (l:keyword != '')
        return s:GetBackEndPathList(l:keyword)
    endif
    let l:keyword = s:IsFrontEnd()
    if (l:keyword != '')
        return s:GetFronEndPathListFromFrontEnd(l:keyword)
    endif
    let l:keyword = s:IsTemplate()
    if (l:keyword != '')
        return s:GetFronEndPathListFromTemplate(l:keyword)
    endif
endfunction

" ---------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

