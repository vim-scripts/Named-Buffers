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
"##### [ }}} ]

"##### Prolog [ {{{ ]
try
	if !gatekeeper#Guard("NamedBuffers")
		finish
	endif
catch /^Vim\%((\a\+)\)\=:E117/
	if &compatible
		finish
	endif
	if exists("loaded_NamedBuffers")
		finish
	endif
	let loaded_NamedBuffers = "1.0"
endtry

let s:save_cpo = &cpo
set cpo&vim
"##### [ }}} ]

"##### Commands [ {{{ ]
"### Command NameBuffer [ {{{ ]
" Description:
"   Give a name to a certain buffer.
"
" Usage:
"   :NameBuffer[!] <buffer number> <buffer name>
"
if !exists(":NameBuffer") || exists("debug_NamedBuffers")
	command! -nargs=+ -bang NameBuffer
				\ :call namedbuffers#NameBuffer(<f-args>, <q-bang>)
endif
"### [ }}} ]
"### Command NameThisBuffer [ {{{ ]
" Description:
"   Give a name to a the current buffer.
"
" Usage:
"   :NameThisBuffer[!] <buffer name>
"
if !exists(":NameThisBuffer") || exists("debug_NamedBuffers")
	command! -nargs=1 -bang NameThisBuffer
				\ :call namedbuffers#NameBuffer(
				\         bufnr("%"), <f-args>, <q-bang>
				\ )
endif
"### [ }}} ]
"### Command UnnameBuffer [ {{{ ]
" Description:
"   Remove the given name from the list.
"
" Usage:
"   :UnnameBuffer <buffer name>
"
if !exists(":UnnameBuffer") || exists("debug_NamedBuffers")
	command! -nargs=1 UnnameBuffer
				\ :call namedbuffers#UnnameBuffer(<f-args>)
endif
"### [ }}} ]
"### Command GotoNamedBuffer [ {{{ ]
" Description:
"   Go to the named buffer.
"
" Usage:
"   :GotoNamedBuffer <buffer name>
"
if !exists(":GotoNamedBuffer") || exists("debug_NamedBuffers")
	command! -nargs=1 GotoNamedBuffer
				\ :execute "b " . namedbuffers#RetrieveBuffer(<f-args>)
endif
"### [ }}} ]
"### Command ListNamedBuffers [ {{{ ]
" Description:
"   List all named buffers, optionally filter by a regular expression.
"
" Usage:
"   :ListNamedBuffers [<filter>]
"
if !exists(":ListNamedBuffers") || exists("debug_NamedBuffers")
	command! -nargs=? ListNamedBuffers
				\ :call namedbuffers#ListBuffers(<f-args>)
endif
"### [ }}} ]
"##### [ }}} ]

"##### Autocommands [ {{{ ]
" Description:
"   We use autocommands to automatically remove a buffer from the
"   translation catalog in case it is deleted.
"
augroup NamedBuffers
	au!
	au BufDelete * :call namedbuffers#RemoveBuffer(expand("<abuf>"))
augroup END
"##### [ }}} ]

"##### Epilog [ {{{ ]
let &cpo = s:save_cpo
unlet s:save_cpo
"##### [ }}} ]
