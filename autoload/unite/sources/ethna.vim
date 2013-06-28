let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
    \ 'name': 'ethna',
    \ }

function! s:unite_source.gather_candidates(args, context)
    let l:list = UniteEthnaGetList()
    return map(l:list, '{
        \ "word": v:val["filename"],
        \ "source": "ethna",
        \ "kind": "file",
        \ "action__path": v:val["filename"],
        \ "action__directory": fnamemodify(v:val["filename"], ":p:h"),
        \ }')
endfunction

function! unite#sources#ethna#define()
  return s:unite_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
