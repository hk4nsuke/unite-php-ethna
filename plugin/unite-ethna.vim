" ethna-jump.vim:
" Load Once:
if &cp || exists("g:loaded_unite_ethna")
    finish
endif
let g:loaded_unite_ethna = 1
let s:keepcpo = &cpo
set cpo&vim
" ---------------------------------------------------------------------

""""""""""" sample """""""""""
"[[{
"    'src': 'frontend/hoge/bar/ja_JP/\([a-zA-Z_]\)\([a-zA-Z_/]*\).tpl$',
"    'filter': [ '/\([A-Z]\)', '/\L\1' ],
"    'dst': 'frontend/hoge/bar/ja_JP/\L\1\E\2.tpl',
"},{
"    'src': 'Service/Hoge/Fuga/\([a-zA-Z]\)\([a-zA-Z_/]*\).php$',
"    'filter': [ '/\([a-z]\)', '/\U\1' ],
"    'dst': 'Service/Hoge/Fuga/\U\1\E\2.php',
"}]]
""""""""""""""""""""""""""""""
"let g:unite_ethna_config = [[{
"\}]]

function! s:FullPath()
    return expand('%:p')
endfunction

function! UniteEthnaGetList()
    let l:path = s:FullPath()
    for s:group in g:unite_ethna_config
        for s:c in s:group
            if (matchstr(l:path, s:c['src']) != '')
                let l:pre  = substitute(l:path, '\(^.*/\)' . s:c['src'], '\1', '')

                let l:index = 1
                let l:patterns = []
                while 1
                    let l:word = substitute(l:path, '^.*/' . s:c['src'], '\' . l:index, '')
                    if (l:word == '')
                        break
                    endif
                    call add(l:patterns, l:word)
                    let l:index = l:index + 1
                endwhile

                let l:list = []
                for s:dc in s:group
                    let l:filtered_pattern = ''
                    let l:base_text = ''
                    for l:pattern in l:patterns
                        let l:word = substitute(l:pattern, s:dc['filter'][0], s:dc['filter'][1], 'g')
                        let l:base_text = l:base_text . l:word
                        let l:filtered_pattern = l:filtered_pattern . '\(' . l:word . '\)'
                    endfor
                    let l:dst = l:pre . substitute(l:base_text, l:filtered_pattern, s:dc['dst'], '')

                    if (glob(l:dst) != '')
                        call add(l:list, {'filename': l:dst})
                    endif
                endfor

                return l:list
            endif
        endfor
    endfor
endfunction

" ---------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

