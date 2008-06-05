"##### Header [ {{{ ]
" File:         NamedBuffers.vim
" Author:       Meikel Brandmeyer <mb@kotka.de>
" Version:      1.0
"
" License:
" Copyright (c) 2008 Meikel Brandmeyer, Frankfurt am Main
" All rights reserved.
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
"
" Description:
" Give a name to a buffer. Later on you can easily switch to that buffer.
"
" This plugin conforms to *write-plugin*.
"##### [ }}} ]

"##### Prolog [ {{{ ]
let s:save_cpo = &cpo
set cpo&vim
"##### [ }}} ]

"##### Variables [ {{{ ]
"### Variable s:catalog [ {{{ ]
" Description:
"   This variable contains the translation information between
"   buffers and names.
"
let s:catalog = {}
"### [ }}} ]
"##### [ }}} ]

"##### Functions [ {{{ ]
"### Function namedbuffers#NameBuffer [ {{{ ]
" Description:
"   Name the given buffer with the given name. %)
"
function! namedbuffers#NameBuffer(bufnum, bufname, bang)
	if has_key(s:catalog, a:bufname) && a:bang == ''
		echoerr "This name is already in use! Use ! to override."
		return
	endif

	let s:catalog[a:bufname] = a:bufnum
endfunction
"### [ }}} ]
"### Function namedbuffers#RetrieveBuffer [ {{{ ]
" Description:
"   Retrieve the buffer of the given name.
"
function! namedbuffers#RetrieveBuffer(bufname)
	if !has_key(s:catalog, a:bufname)
		throw "NamedBuffers:No such name defined!"
	endif

	return s:catalog[a:bufname]
endfunction
"### [ }}} ]
"### Function namedbuffers#UnnameBuffer [ {{{ ]
" Description:
"   Remove only a single name of a buffer. In case there are
"   more references to the same buffer they are not touched.
"
function! namedbuffers#UnnameBuffer(bufname)
	if !has_key(s:catalog, a:bufname)
		throw "NamedBuffers:No such name defined!"
	endif

	unlet s:catalog[a:bufname]
endfunction
"### [ }}} ]
"### Function namedbuffers#RemoveBuffer [ {{{ ]
" Description:
"   Remove the buffer given by the buffer number from the
"   translation catalog.
"
function! namedbuffers#RemoveBuffer(bufnum)
	" We have to scan the whole catalog, since the buffer
	" may have several names.
	for [key, value] in items(s:catalog)
		if value == a:bufnum
			unlet s:catalog[key]
		endif
	endfor
endfunction
"### [ }}} ]
"### Function namedbuffers#ListBuffers [ {{{ ]
" Description:
"   List all named buffers together with their buffer number.
"
function! namedbuffers#ListBuffers(...)
	let filter = len(a:000) > 0 ? a:1 : '.*'

	let l = ""
	for [key, value] in items(s:catalog)
		if key =~ filter
			let l = l . "  '" . key . "' " . value . "\n"
		endif
	endfor

	echo l
endfunction
"### [ }}} ]
"##### [ }}} ]

"##### Epilog [ {{{ ]
let &cpo = s:save_cpo
unlet s:save_cpo
"##### [ }}} ]
