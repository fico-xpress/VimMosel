" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin/02tlib.vim	[[[1
118
" tlib.vim -- Some utility functions
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-04-10.
" @Last Change: 2013-09-25.
" @Revision:    749
" GetLatestVimScripts: 1863 1 tlib.vim

if &cp || exists("loaded_tlib")
    finish
endif
if v:version < 700 "{{{2
    echoerr "tlib requires Vim >= 7"
    finish
endif
let loaded_tlib = 108

let s:save_cpo = &cpo
set cpo&vim


" Init~ {{{1
" call tlib#autocmdgroup#Init()


" Commands~ {{{1

" :display: :TRequire NAME [VERSION [FILE]]
" Make a certain vim file is loaded.
"
" Conventions: If FILE isn't defined, plugin/NAME.vim is loaded. The 
" file must provide a variable loaded_{NAME} that represents the version 
" number.
command! -nargs=+ TRequire let s:require = [<f-args>]
            \ | if !exists('loaded_'. get(s:require, 0))
                \ | exec 'runtime '. get(s:require, 2, 'plugin/'. get(s:require, 0) .'.vim')
                \ | if !exists('loaded_'. get(s:require, 0)) || loaded_{get(s:require, 0)} < get(s:require, 1, loaded_{get(s:require, 0)})
                    \ | echoerr 'Require '.  get(s:require, 0) .' >= '. get(s:require, 1, 'any version will do')
                    \ | finish
                    \ | endif
                \ | endif | unlet s:require


" :display: :TLet VAR = VALUE
" Set a variable only if it doesn't already exist.
" EXAMPLES: >
"   TLet foo = 1
"   TLet foo = 2
"   echo foo
"   => 1
command! -nargs=+ TLet if !exists(matchstr(<q-args>, '^[^=[:space:]]\+')) | exec 'let '. <q-args> | endif


" Open a scratch buffer (a buffer without a file).
"   TScratch  ... use split window
"   TScratch! ... use the whole frame
" This command takes an (inner) dictionary as optional argument.
" EXAMPLES: >
"   TScratch 'scratch': '__FOO__'
"   => Open a scratch buffer named __FOO__
command! -bar -nargs=* -bang TScratch call tlib#scratch#UseScratch({'scratch_split': '<bang>' != '!', <args>})


" :display: :TVarArg VAR1, [VAR2, DEFAULT2] ...
" A convenience wrapper for |tlib#arg#Let|.
" EXAMPLES: >
"   function! Foo(...)
"       TVarArg ['a', 1], 'b'
"       echo 'a='. a
"       echo 'b='. b
"   endf
command! -nargs=+ TVarArg exec tlib#arg#Let([<args>])


" :display: :TKeyArg DICT, VAR1, [VAR2, DEFAULT2] ...
" A convenience wrapper for |tlib#arg#Let|.
" EXAMPLES: >
"   function! Foo(keyargs)
"       TKeyArg a:keyargs, ['a', 1], 'b'
"       echo 'a='. a
"       echo 'b='. b
"   endf
command! -nargs=+ TKeyArg exec tlib#arg#Key([<args>])


" :display: :TBrowseOutput COMMAND
" Ever wondered how to efficiently browse the output of a command 
" without redirecting it to a file? This command takes a command as 
" argument and presents the output via |tlib#input#List()| so that you 
" can easily search for a keyword (e.g. the name of a variable or 
" function) and the like.
"
" If you press enter, the selected line will be copied to the command 
" line. Press ESC to cancel browsing.
"
" EXAMPLES: >
"   TBrowseOutput 20verb TeaseTheCulprit
command! -nargs=1 -complete=command TBrowseOutput call tlib#cmd#BrowseOutput(<q-args>)

" :display: :TBrowseScriptnames
" List all sourced script names (the output of ':scriptnames').
"
" When you press enter, the selected script will be opened in the current
" window. Press ESC to cancel.
"
" EXAMPLES: >
"   TBrowseScriptnames 
command! -nargs=0 -complete=command TBrowseScriptnames call
            \ tlib#cmd#BrowseOutputWithCallback("tlib#cmd#ParseScriptname", "scriptnames")

" :display: :TTimeCommand CMD
" Time the execution time of CMD.
command! -nargs=1 -complete=command TTimeCommand call tlib#cmd#Time(<q-args>)


let &cpo = s:save_cpo
unlet s:save_cpo
doc/tlib.txt	[[[1
2087
*tlib.txt*  tlib -- A library of vim functions
            Author: Tom Link, micathom at gmail com

This library provides some utility functions. There isn't much need to 
install it unless another plugin requires you to do so.

Most of the library is included in autoload files. No autocommands are 
created. With the exception of loading ../plugin/02tlib.vim at startup 
the library has no impact on startup time or anything else.

The change-log is included at the bottom of ../plugin/02tlib.vim
(move the cursor over the file name and type gfG)

Demo of |tlib#input#List()|: 
http://vimsomnia.blogspot.com/2010/11/selecting-items-from-list-with-tlibs.html


-----------------------------------------------------------------------
Install~

Edit the vba file and type: >

    :so %

See :help vimball for details. If you have difficulties, please make 
sure, you have the current version of vimball (vimscript #1502) 
installed.


========================================================================
Contents~

        :TRequire .............................. |:TRequire|
        :TLet .................................. |:TLet|
        :TScratch .............................. |:TScratch|
        :TVarArg ............................... |:TVarArg|
        :TKeyArg ............................... |:TKeyArg|
        :TBrowseOutput ......................... |:TBrowseOutput|
        :TBrowseScriptnames .................... |:TBrowseScriptnames|
        :TTimeCommand .......................... |:TTimeCommand|
        Add .................................... |Add()|
        TestGetArg ............................. |TestGetArg()|
        TestGetArg1 ............................ |TestGetArg1()|
        TestArgs ............................... |TestArgs()|
        TestArgs1 .............................. |TestArgs1()|
        TestArgs2 .............................. |TestArgs2()|
        TestArgs3 .............................. |TestArgs3()|
        g:tlib#debug ........................... |g:tlib#debug|
        tlib#notify#Echo ....................... |tlib#notify#Echo()|
        tlib#notify#TrimMessage ................ |tlib#notify#TrimMessage()|
        g:tlib_persistent ...................... |g:tlib_persistent|
        tlib#persistent#Dir .................... |tlib#persistent#Dir()|
        tlib#persistent#Filename ............... |tlib#persistent#Filename()|
        tlib#persistent#Get .................... |tlib#persistent#Get()|
        tlib#persistent#Value .................. |tlib#persistent#Value()|
        tlib#persistent#Save ................... |tlib#persistent#Save()|
        g:tlib#vim#simalt_maximize ............. |g:tlib#vim#simalt_maximize|
        g:tlib#vim#simalt_restore .............. |g:tlib#vim#simalt_restore|
        g:tlib#vim#use_vimtweak ................ |g:tlib#vim#use_vimtweak|
        tlib#vim#Maximize ...................... |tlib#vim#Maximize()|
        tlib#vim#RestoreWindow ................. |tlib#vim#RestoreWindow()|
        g:tlib#vim#use_wmctrl .................. |g:tlib#vim#use_wmctrl|
        tlib#vim#CopyFunction .................. |tlib#vim#CopyFunction()|
        tlib#progressbar#Init .................. |tlib#progressbar#Init()|
        tlib#progressbar#Display ............... |tlib#progressbar#Display()|
        tlib#progressbar#Restore ............... |tlib#progressbar#Restore()|
        tlib#eval#FormatValue .................. |tlib#eval#FormatValue()|
        tlib#list#Inject ....................... |tlib#list#Inject()|
        tlib#list#Compact ...................... |tlib#list#Compact()|
        tlib#list#Flatten ...................... |tlib#list#Flatten()|
        tlib#list#FindAll ...................... |tlib#list#FindAll()|
        tlib#list#Find ......................... |tlib#list#Find()|
        tlib#list#Any .......................... |tlib#list#Any()|
        tlib#list#All .......................... |tlib#list#All()|
        tlib#list#Remove ....................... |tlib#list#Remove()|
        tlib#list#RemoveAll .................... |tlib#list#RemoveAll()|
        tlib#list#Zip .......................... |tlib#list#Zip()|
        tlib#list#Uniq ......................... |tlib#list#Uniq()|
        tlib#cmd#OutputAsList .................. |tlib#cmd#OutputAsList()|
        tlib#cmd#BrowseOutput .................. |tlib#cmd#BrowseOutput()|
        tlib#cmd#BrowseOutputWithCallback ...... |tlib#cmd#BrowseOutputWithCallback()|
        tlib#cmd#DefaultBrowseOutput ........... |tlib#cmd#DefaultBrowseOutput()|
        tlib#cmd#ParseScriptname ............... |tlib#cmd#ParseScriptname()|
        tlib#cmd#UseVertical ................... |tlib#cmd#UseVertical()|
        tlib#cmd#Time .......................... |tlib#cmd#Time()|
        tlib#syntax#Collect .................... |tlib#syntax#Collect()|
        tlib#syntax#Names ...................... |tlib#syntax#Names()|
        tlib#balloon#Register .................. |tlib#balloon#Register()|
        tlib#balloon#Remove .................... |tlib#balloon#Remove()|
        tlib#balloon#Expr ...................... |tlib#balloon#Expr()|
        g:tlib#vcs#def ......................... |g:tlib#vcs#def|
        g:tlib#vcs#executables ................. |g:tlib#vcs#executables|
        g:tlib#vcs#check ....................... |g:tlib#vcs#check|
        tlib#vcs#FindVCS ....................... |tlib#vcs#FindVCS()|
        tlib#vcs#Ls ............................ |tlib#vcs#Ls()|
        tlib#vcs#Diff .......................... |tlib#vcs#Diff()|
        tlib#char#Get .......................... |tlib#char#Get()|
        tlib#char#IsAvailable .................. |tlib#char#IsAvailable()|
        tlib#char#GetWithTimeout ............... |tlib#char#GetWithTimeout()|
        g:tlib#Filter_glob#seq ................. |g:tlib#Filter_glob#seq|
        g:tlib#Filter_glob#char ................ |g:tlib#Filter_glob#char|
        tlib#Filter_glob#New ................... |tlib#Filter_glob#New()|
        g:tlib_scratch_pos ..................... |g:tlib_scratch_pos|
        g:tlib#scratch#hidden .................. |g:tlib#scratch#hidden|
        tlib#scratch#UseScratch ................ |tlib#scratch#UseScratch()|
        tlib#scratch#CloseScratch .............. |tlib#scratch#CloseScratch()|
        tlib#autocmdgroup#Init ................. |tlib#autocmdgroup#Init()|
        g:tlib_cache ........................... |g:tlib_cache|
        g:tlib#cache#purge_days ................ |g:tlib#cache#purge_days|
        g:tlib#cache#purge_every_days .......... |g:tlib#cache#purge_every_days|
        g:tlib#cache#script_encoding ........... |g:tlib#cache#script_encoding|
        g:tlib#cache#run_script ................ |g:tlib#cache#run_script|
        g:tlib#cache#verbosity ................. |g:tlib#cache#verbosity|
        g:tlib#cache#dont_purge ................ |g:tlib#cache#dont_purge|
        g:tlib#cache#max_filename .............. |g:tlib#cache#max_filename|
        tlib#cache#Dir ......................... |tlib#cache#Dir()|
        tlib#cache#Filename .................... |tlib#cache#Filename()|
        tlib#cache#Save ........................ |tlib#cache#Save()|
        tlib#cache#Get ......................... |tlib#cache#Get()|
        tlib#cache#Value ....................... |tlib#cache#Value()|
        tlib#cache#MaybePurge .................. |tlib#cache#MaybePurge()|
        tlib#cache#Purge ....................... |tlib#cache#Purge()|
        tlib#cache#ListFilesInCache ............ |tlib#cache#ListFilesInCache()|
        tlib#normal#WithRegister ............... |tlib#normal#WithRegister()|
        tlib#time#MSecs ........................ |tlib#time#MSecs()|
        tlib#time#Now .......................... |tlib#time#Now()|
        tlib#time#Diff ......................... |tlib#time#Diff()|
        tlib#time#DiffMSecs .................... |tlib#time#DiffMSecs()|
        tlib#var#Let ........................... |tlib#var#Let()|
        tlib#var#EGet .......................... |tlib#var#EGet()|
        tlib#var#Get ........................... |tlib#var#Get()|
        tlib#var#List .......................... |tlib#var#List()|
        g:tlib_scroll_lines .................... |g:tlib_scroll_lines|
        tlib#agent#Exit ........................ |tlib#agent#Exit()|
        tlib#agent#CopyItems ................... |tlib#agent#CopyItems()|
        tlib#agent#PageUp ...................... |tlib#agent#PageUp()|
        tlib#agent#PageDown .................... |tlib#agent#PageDown()|
        tlib#agent#Home ........................ |tlib#agent#Home()|
        tlib#agent#End ......................... |tlib#agent#End()|
        tlib#agent#Up .......................... |tlib#agent#Up()|
        tlib#agent#Down ........................ |tlib#agent#Down()|
        tlib#agent#UpN ......................... |tlib#agent#UpN()|
        tlib#agent#DownN ....................... |tlib#agent#DownN()|
        tlib#agent#ShiftLeft ................... |tlib#agent#ShiftLeft()|
        tlib#agent#ShiftRight .................. |tlib#agent#ShiftRight()|
        tlib#agent#Reset ....................... |tlib#agent#Reset()|
        tlib#agent#ToggleRestrictView .......... |tlib#agent#ToggleRestrictView()|
        tlib#agent#RestrictView ................ |tlib#agent#RestrictView()|
        tlib#agent#UnrestrictView .............. |tlib#agent#UnrestrictView()|
        tlib#agent#Input ....................... |tlib#agent#Input()|
        tlib#agent#SuspendToParentWindow ....... |tlib#agent#SuspendToParentWindow()|
        tlib#agent#Suspend ..................... |tlib#agent#Suspend()|
        tlib#agent#Help ........................ |tlib#agent#Help()|
        tlib#agent#OR .......................... |tlib#agent#OR()|
        tlib#agent#AND ......................... |tlib#agent#AND()|
        tlib#agent#ReduceFilter ................ |tlib#agent#ReduceFilter()|
        tlib#agent#PopFilter ................... |tlib#agent#PopFilter()|
        tlib#agent#Debug ....................... |tlib#agent#Debug()|
        tlib#agent#Select ...................... |tlib#agent#Select()|
        tlib#agent#SelectUp .................... |tlib#agent#SelectUp()|
        tlib#agent#SelectDown .................. |tlib#agent#SelectDown()|
        tlib#agent#SelectAll ................... |tlib#agent#SelectAll()|
        tlib#agent#ToggleStickyList ............ |tlib#agent#ToggleStickyList()|
        tlib#agent#EditItem .................... |tlib#agent#EditItem()|
        tlib#agent#NewItem ..................... |tlib#agent#NewItem()|
        tlib#agent#DeleteItems ................. |tlib#agent#DeleteItems()|
        tlib#agent#Cut ......................... |tlib#agent#Cut()|
        tlib#agent#Copy ........................ |tlib#agent#Copy()|
        tlib#agent#Paste ....................... |tlib#agent#Paste()|
        tlib#agent#EditReturnValue ............. |tlib#agent#EditReturnValue()|
        tlib#agent#ViewFile .................... |tlib#agent#ViewFile()|
        tlib#agent#EditFile .................... |tlib#agent#EditFile()|
        tlib#agent#EditFileInSplit ............. |tlib#agent#EditFileInSplit()|
        tlib#agent#EditFileInVSplit ............ |tlib#agent#EditFileInVSplit()|
        tlib#agent#EditFileInTab ............... |tlib#agent#EditFileInTab()|
        tlib#agent#ToggleScrollbind ............ |tlib#agent#ToggleScrollbind()|
        tlib#agent#ShowInfo .................... |tlib#agent#ShowInfo()|
        tlib#agent#PreviewLine ................. |tlib#agent#PreviewLine()|
        tlib#agent#GotoLine .................... |tlib#agent#GotoLine()|
        tlib#agent#DoAtLine .................... |tlib#agent#DoAtLine()|
        tlib#agent#Wildcard .................... |tlib#agent#Wildcard()|
        tlib#agent#Null ........................ |tlib#agent#Null()|
        tlib#agent#ExecAgentByName ............. |tlib#agent#ExecAgentByName()|
        tlib#agent#CompleteAgentNames .......... |tlib#agent#CompleteAgentNames()|
        tlib#bitwise#Num2Bits .................. |tlib#bitwise#Num2Bits()|
        tlib#bitwise#Bits2Num .................. |tlib#bitwise#Bits2Num()|
        tlib#bitwise#AND ....................... |tlib#bitwise#AND()|
        tlib#bitwise#OR ........................ |tlib#bitwise#OR()|
        tlib#bitwise#XOR ....................... |tlib#bitwise#XOR()|
        tlib#bitwise#ShiftRight ................ |tlib#bitwise#ShiftRight()|
        tlib#bitwise#ShiftLeft ................. |tlib#bitwise#ShiftLeft()|
        tlib#bitwise#Add ....................... |tlib#bitwise#Add()|
        tlib#bitwise#Sub ....................... |tlib#bitwise#Sub()|
        tlib#url#Decode ........................ |tlib#url#Decode()|
        tlib#url#DecodeChar .................... |tlib#url#DecodeChar()|
        tlib#url#EncodeChar .................... |tlib#url#EncodeChar()|
        tlib#url#Encode ........................ |tlib#url#Encode()|
        tlib#signs#ClearAll .................... |tlib#signs#ClearAll()|
        tlib#signs#ClearBuffer ................. |tlib#signs#ClearBuffer()|
        tlib#signs#Mark ........................ |tlib#signs#Mark()|
        tlib#rx#Escape ......................... |tlib#rx#Escape()|
        tlib#rx#EscapeReplace .................. |tlib#rx#EscapeReplace()|
        tlib#rx#Suffixes ....................... |tlib#rx#Suffixes()|
        g:tlib_tags_extra ...................... |g:tlib_tags_extra|
        g:tlib_tag_substitute .................. |g:tlib_tag_substitute|
        tlib#tag#Retrieve ...................... |tlib#tag#Retrieve()|
        tlib#tag#Collect ....................... |tlib#tag#Collect()|
        tlib#tag#Format ........................ |tlib#tag#Format()|
        tlib#map#PumAccept ..................... |tlib#map#PumAccept()|
        tlib#Filter_cnfd#New ................... |tlib#Filter_cnfd#New()|
        g:tlib#input#sortprefs_threshold ....... |g:tlib#input#sortprefs_threshold|
        g:tlib#input#livesearch_threshold ...... |g:tlib#input#livesearch_threshold|
        g:tlib#input#filter_mode ............... |g:tlib#input#filter_mode|
        g:tlib#input#higroup ................... |g:tlib#input#higroup|
        g:tlib_pick_last_item .................. |g:tlib_pick_last_item|
        g:tlib#input#and ....................... |g:tlib#input#and|
        g:tlib#input#or ........................ |g:tlib#input#or|
        g:tlib#input#not ....................... |g:tlib#input#not|
        g:tlib#input#numeric_chars ............. |g:tlib#input#numeric_chars|
        g:tlib#input#keyagents_InputList_s ..... |g:tlib#input#keyagents_InputList_s|
        g:tlib#input#keyagents_InputList_m ..... |g:tlib#input#keyagents_InputList_m|
        g:tlib#input#handlers_EditList ......... |g:tlib#input#handlers_EditList|
        g:tlib#input#use_popup ................. |g:tlib#input#use_popup|
        g:tlib#input#format_filename ........... |g:tlib#input#format_filename|
        g:tlib#input#filename_padding_r ........ |g:tlib#input#filename_padding_r|
        g:tlib#input#filename_max_width ........ |g:tlib#input#filename_max_width|
        tlib#input#List ........................ |tlib#input#List()|
        tlib#input#ListD ....................... |tlib#input#ListD()|
        tlib#input#ListW ....................... |tlib#input#ListW()|
        tlib#input#EditList .................... |tlib#input#EditList()|
        tlib#input#Resume ...................... |tlib#input#Resume()|
        tlib#input#CommandSelect ............... |tlib#input#CommandSelect()|
        tlib#input#Edit ........................ |tlib#input#Edit()|
        tlib#input#Dialog ...................... |tlib#input#Dialog()|
        tlib#number#ConvertBase ................ |tlib#number#ConvertBase()|
        tlib#file#Split ........................ |tlib#file#Split()|
        tlib#file#Join ......................... |tlib#file#Join()|
        tlib#file#Relative ..................... |tlib#file#Relative()|
        tlib#file#Absolute ..................... |tlib#file#Absolute()|
        tlib#file#With ......................... |tlib#file#With()|
        tlib#paragraph#GetMetric ............... |tlib#paragraph#GetMetric()|
        tlib#paragraph#Move .................... |tlib#paragraph#Move()|
        g:tlib_inputlist_pct ................... |g:tlib_inputlist_pct|
        g:tlib_inputlist_width_filename ........ |g:tlib_inputlist_width_filename|
        g:tlib_inputlist_filename_indicators ... |g:tlib_inputlist_filename_indicators|
        g:tlib_inputlist_shortmessage .......... |g:tlib_inputlist_shortmessage|
        tlib#World#New ......................... |tlib#World#New()|
        prototype.PrintLines
        prototype.Suspend
        tlib#tab#BufMap ........................ |tlib#tab#BufMap()|
        tlib#tab#TabWinNr ...................... |tlib#tab#TabWinNr()|
        tlib#tab#Set ........................... |tlib#tab#Set()|
        tlib#date#DiffInDays ................... |tlib#date#DiffInDays()|
        tlib#date#Parse ........................ |tlib#date#Parse()|
        tlib#date#SecondsSince1970 ............. |tlib#date#SecondsSince1970()|
        tlib#type#IsNumber ..................... |tlib#type#IsNumber()|
        tlib#type#IsString ..................... |tlib#type#IsString()|
        tlib#type#IsFuncref .................... |tlib#type#IsFuncref()|
        tlib#type#IsList ....................... |tlib#type#IsList()|
        tlib#type#IsDictionary ................. |tlib#type#IsDictionary()|
        tlib#Filter_fuzzy#New .................. |tlib#Filter_fuzzy#New()|
        tlib#textobjects#StandardParagraph ..... |standard-paragraph|
        tlib#textobjects#Init .................. |tlib#textobjects#Init()|
        v_sp ................................... |v_sp|
        o_sp ................................... |o_sp|
        tlib#arg#Get ........................... |tlib#arg#Get()|
        tlib#arg#Let ........................... |tlib#arg#Let()|
        tlib#arg#Key ........................... |tlib#arg#Key()|
        tlib#arg#StringAsKeyArgs ............... |tlib#arg#StringAsKeyArgs()|
        tlib#arg#Ex ............................ |tlib#arg#Ex()|
        tlib#fixes#Winpos ...................... |tlib#fixes#Winpos()|
        g:tlib#dir#sep ......................... |g:tlib#dir#sep|
        tlib#dir#CanonicName ................... |tlib#dir#CanonicName()|
        tlib#dir#NativeName .................... |tlib#dir#NativeName()|
        tlib#dir#PlainName ..................... |tlib#dir#PlainName()|
        tlib#dir#Ensure ........................ |tlib#dir#Ensure()|
        tlib#dir#MyRuntime ..................... |tlib#dir#MyRuntime()|
        tlib#dir#CD ............................ |tlib#dir#CD()|
        tlib#dir#Push .......................... |tlib#dir#Push()|
        tlib#dir#Pop ........................... |tlib#dir#Pop()|
        g:tlib#hash#use_crc32 .................. |g:tlib#hash#use_crc32|
        g:tlib#hash#use_adler32 ................ |g:tlib#hash#use_adler32|
        tlib#hash#CRC32B ....................... |tlib#hash#CRC32B()|
        tlib#hash#CRC32B_ruby .................. |tlib#hash#CRC32B_ruby()|
        tlib#hash#CRC32B_vim ................... |tlib#hash#CRC32B_vim()|
        tlib#hash#Adler32 ...................... |tlib#hash#Adler32()|
        tlib#hash#Adler32_vim .................. |tlib#hash#Adler32_vim()|
        tlib#hash#Adler32_tlib ................. |tlib#hash#Adler32_tlib()|
        tlib#win#Set ........................... |tlib#win#Set()|
        tlib#win#GetLayout ..................... |tlib#win#GetLayout()|
        tlib#win#SetLayout ..................... |tlib#win#SetLayout()|
        tlib#win#List .......................... |tlib#win#List()|
        tlib#win#Width ......................... |tlib#win#Width()|
        tlib#win#WinDo ......................... |tlib#win#WinDo()|
        tlib#comments#Comments ................. |tlib#comments#Comments()|
        tlib#grep#Do ........................... |tlib#grep#Do()|
        tlib#grep#LocList ...................... |tlib#grep#LocList()|
        tlib#grep#QuickFixList ................. |tlib#grep#QuickFixList()|
        tlib#grep#List ......................... |tlib#grep#List()|
        tlib#Filter_cnf#New .................... |tlib#Filter_cnf#New()|
        prototype.Pretty
        tlib#Object#New ........................ |tlib#Object#New()|
        prototype.New
        prototype.Inherit
        prototype.Extend
        prototype.IsA
        prototype.IsRelated
        prototype.RespondTo
        prototype.Super
        tlib#Object#Methods .................... |tlib#Object#Methods()|
        g:tlib_viewline_position ............... |g:tlib_viewline_position|
        tlib#buffer#EnableMRU .................. |tlib#buffer#EnableMRU()|
        tlib#buffer#DisableMRU ................. |tlib#buffer#DisableMRU()|
        tlib#buffer#Set ........................ |tlib#buffer#Set()|
        tlib#buffer#Eval ....................... |tlib#buffer#Eval()|
        tlib#buffer#GetList .................... |tlib#buffer#GetList()|
        tlib#buffer#ViewLine ................... |tlib#buffer#ViewLine()|
        tlib#buffer#HighlightLine .............. |tlib#buffer#HighlightLine()|
        tlib#buffer#DeleteRange ................ |tlib#buffer#DeleteRange()|
        tlib#buffer#ReplaceRange ............... |tlib#buffer#ReplaceRange()|
        tlib#buffer#ScratchStart ............... |tlib#buffer#ScratchStart()|
        tlib#buffer#ScratchEnd ................. |tlib#buffer#ScratchEnd()|
        tlib#buffer#BufDo ...................... |tlib#buffer#BufDo()|
        tlib#buffer#InsertText ................. |tlib#buffer#InsertText()|
        tlib#buffer#InsertText0 ................ |tlib#buffer#InsertText0()|
        tlib#buffer#CurrentByte ................ |tlib#buffer#CurrentByte()|
        tlib#buffer#KeepCursorPosition ......... |tlib#buffer#KeepCursorPosition()|
        tlib#hook#Run .......................... |tlib#hook#Run()|
        tlib#string#RemoveBackslashes .......... |tlib#string#RemoveBackslashes()|
        tlib#string#Chomp ...................... |tlib#string#Chomp()|
        tlib#string#Format ..................... |tlib#string#Format()|
        tlib#string#Printf1 .................... |tlib#string#Printf1()|
        tlib#string#TrimLeft ................... |tlib#string#TrimLeft()|
        tlib#string#TrimRight .................. |tlib#string#TrimRight()|
        tlib#string#Strip ...................... |tlib#string#Strip()|
        tlib#string#Count ...................... |tlib#string#Count()|


========================================================================
plugin/02tlib.vim~

                                                    *:TRequire*
:TRequire NAME [VERSION [FILE]]
    Make a certain vim file is loaded.

    Conventions: If FILE isn't defined, plugin/NAME.vim is loaded. The 
    file must provide a variable loaded_{NAME} that represents the version 
    number.

                                                    *:TLet*
:TLet VAR = VALUE
    Set a variable only if it doesn't already exist.
    EXAMPLES: >
      TLet foo = 1
      TLet foo = 2
      echo foo
      => 1
<

                                                    *:TScratch*
:TScratch
    Open a scratch buffer (a buffer without a file).
      TScratch  ... use split window
      TScratch! ... use the whole frame
    This command takes an (inner) dictionary as optional argument.
    EXAMPLES: >
      TScratch 'scratch': '__FOO__'
      => Open a scratch buffer named __FOO__
<

                                                    *:TVarArg*
:TVarArg VAR1, [VAR2, DEFAULT2] ...
    A convenience wrapper for |tlib#arg#Let|.
    EXAMPLES: >
      function! Foo(...)
          TVarArg ['a', 1], 'b'
          echo 'a='. a
          echo 'b='. b
      endf
<

                                                    *:TKeyArg*
:TKeyArg DICT, VAR1, [VAR2, DEFAULT2] ...
    A convenience wrapper for |tlib#arg#Let|.
    EXAMPLES: >
      function! Foo(keyargs)
          TKeyArg a:keyargs, ['a', 1], 'b'
          echo 'a='. a
          echo 'b='. b
      endf
<

                                                    *:TBrowseOutput*
:TBrowseOutput COMMAND
    Ever wondered how to efficiently browse the output of a command 
    without redirecting it to a file? This command takes a command as 
    argument and presents the output via |tlib#input#List()| so that you 
    can easily search for a keyword (e.g. the name of a variable or 
    function) and the like.

    If you press enter, the selected line will be copied to the command 
    line. Press ESC to cancel browsing.

    EXAMPLES: >
      TBrowseOutput 20verb TeaseTheCulprit
<

                                                    *:TBrowseScriptnames*
:TBrowseScriptnames
    List all sourced script names (the output of ':scriptnames').

    When you press enter, the selected script will be opened in the current
    window. Press ESC to cancel.

    EXAMPLES: >
      TBrowseScriptnames 
<

                                                    *:TTimeCommand*
:TTimeCommand CMD
    Time the execution time of CMD.


========================================================================
test/tlib.vim~

                                                    *Add()*
Add(a,b)
    List

                                                    *TestGetArg()*
TestGetArg(...)
    Optional arguments

                                                    *TestGetArg1()*
TestGetArg1(...)

                                                    *TestArgs()*
TestArgs(...)

                                                    *TestArgs1()*
TestArgs1(...)

                                                    *TestArgs2()*
TestArgs2(...)

                                                    *TestArgs3()*
TestArgs3(...)


========================================================================
autoload/tlib.vim~

                                                    *g:tlib#debug*
g:tlib#debug


========================================================================
autoload/tlib/notify.vim~

                                                    *tlib#notify#Echo()*
tlib#notify#Echo(text, ?style='')
    Print text in the echo area. Temporarily disable 'ruler' and 'showcmd' 
    in order to prevent |press-enter| messages.

                                                    *tlib#notify#TrimMessage()*
tlib#notify#TrimMessage(message)
    Contributed by Erik Falor:
    If the line containing the message is too long, echoing it will cause 
    a 'Hit ENTER' prompt to appear.  This function cleans up the line so 
    that does not happen.
    The echoed line is too long if it is wider than the width of the 
    window, minus cmdline space taken up by the ruler and showcmd 
    features.


========================================================================
autoload/tlib/persistent.vim~

                                                    *g:tlib_persistent*
g:tlib_persistent              (default: '')
    The directory for persistent data files. If empty, use 
    |tlib#dir#MyRuntime|.'/share'.

                                                    *tlib#persistent#Dir()*
tlib#persistent#Dir(?mode = 'bg')
    Return the full directory name for persistent data files.

                                                    *tlib#persistent#Filename()*
tlib#persistent#Filename(type, ?file=%, ?mkdir=0)

                                                    *tlib#persistent#Get()*
tlib#persistent#Get(...)

                                                    *tlib#persistent#Value()*
tlib#persistent#Value(...)

                                                    *tlib#persistent#Save()*
tlib#persistent#Save(cfile, dictionary)


========================================================================
autoload/tlib/vim.vim~

                                                    *g:tlib#vim#simalt_maximize*
g:tlib#vim#simalt_maximize     (default: 'x')
    The alt-key for maximizing the window.
    CAUTION: The value of this paramter depends on your locale and 
    maybe the windows version you are running.

                                                    *g:tlib#vim#simalt_restore*
g:tlib#vim#simalt_restore      (default: 'r')
    The alt-key for restoring the window.
    CAUTION: The value of this paramter depends on your locale and 
    maybe the windows version you are running.

                                                    *g:tlib#vim#use_vimtweak*
g:tlib#vim#use_vimtweak        (default: 0)
    If true, use the vimtweak.dll for windows. This will enable 
    tlib to remove the caption for fullscreen windows.

                                                    *tlib#vim#Maximize()*
tlib#vim#Maximize(fullscreen)
    Maximize the window.
    You might need to redefine |g:tlib#vim#simalt_maximize| if it doesn't 
    work for you.

                                                    *tlib#vim#RestoreWindow()*
tlib#vim#RestoreWindow()
    Restore the original vimsize after having called |tlib#vim#Maximize()|.

                                                    *g:tlib#vim#use_wmctrl*
g:tlib#vim#use_wmctrl          (default: executable('wmctrl'))
    If true, use wmctrl for X windows to make a window 
    maximized/fullscreen.

    This is the preferred method for maximizing windows under X 
    windows. Some window managers have problem coping with the 
    default method of setting 'lines' and 'columns' to a large 
    value.

                                                    *tlib#vim#CopyFunction()*
tlib#vim##CopyFunction(old, new, overwrite=0)


========================================================================
autoload/tlib/progressbar.vim~

                                                    *tlib#progressbar#Init()*
tlib#progressbar#Init(max, ...)
    EXAMPLE: >
        call tlib#progressbar#Init(20)
        try
            for i in range(20)
                call tlib#progressbar#Display(i)
                call DoSomethingThatTakesSomeTime(i)
            endfor
        finally
            call tlib#progressbar#Restore()
        endtry
<

                                                    *tlib#progressbar#Display()*
tlib#progressbar#Display(value, ...)

                                                    *tlib#progressbar#Restore()*
tlib#progressbar#Restore()


========================================================================
autoload/tlib/eval.vim~

                                                    *tlib#eval#FormatValue()*
tlib#eval#FormatValue(value, ...)


========================================================================
autoload/tlib/list.vim~

                                                    *tlib#list#Inject()*
tlib#list#Inject(list, initial_value, funcref)
    EXAMPLES: >
      echo tlib#list#Inject([1,2,3], 0, function('Add')
      => 6
<

                                                    *tlib#list#Compact()*
tlib#list#Compact(list)
    EXAMPLES: >
      tlib#list#Compact([0,1,2,3,[], {}, ""])
      => [1,2,3]
<

                                                    *tlib#list#Flatten()*
tlib#list#Flatten(list)
    EXAMPLES: >
      tlib#list#Flatten([0,[1,2,[3,""]]])
      => [0,1,2,3,""]
<

                                                    *tlib#list#FindAll()*
tlib#list#FindAll(list, filter, ?process_expr="")
    Basically the same as filter()

    EXAMPLES: >
      tlib#list#FindAll([1,2,3], 'v:val >= 2')
      => [2, 3]
<

                                                    *tlib#list#Find()*
tlib#list#Find(list, filter, ?default="", ?process_expr="")

    EXAMPLES: >
      tlib#list#Find([1,2,3], 'v:val >= 2')
      => 2
<

                                                    *tlib#list#Any()*
tlib#list#Any(list, expr)
    EXAMPLES: >
      tlib#list#Any([1,2,3], 'v:val >= 2')
      => 1
<

                                                    *tlib#list#All()*
tlib#list#All(list, expr)
    EXAMPLES: >
      tlib#list#All([1,2,3], 'v:val >= 2')
      => 0
<

                                                    *tlib#list#Remove()*
tlib#list#Remove(list, element)
    EXAMPLES: >
      tlib#list#Remove([1,2,1,2], 2)
      => [1,1,2]
<

                                                    *tlib#list#RemoveAll()*
tlib#list#RemoveAll(list, element)
    EXAMPLES: >
      tlib#list#RemoveAll([1,2,1,2], 2)
      => [1,1]
<

                                                    *tlib#list#Zip()*
tlib#list#Zip(lists, ?default='')
    EXAMPLES: >
      tlib#list#Zip([[1,2,3], [4,5,6]])
      => [[1,4], [2,5], [3,6]]
<

                                                    *tlib#list#Uniq()*
tlib#list#Uniq(list, ...)


========================================================================
autoload/tlib/cmd.vim~

                                                    *tlib#cmd#OutputAsList()*
tlib#cmd#OutputAsList(command)

                                                    *tlib#cmd#BrowseOutput()*
tlib#cmd#BrowseOutput(command)
    See |:TBrowseOutput|.

                                                    *tlib#cmd#BrowseOutputWithCallback()*
tlib#cmd#BrowseOutputWithCallback(callback, command)
    Execute COMMAND and present its output in a |tlib#input#List()|;
    when a line is selected, execute the function named as the CALLBACK
    and pass in that line as an argument.

    The CALLBACK function gives you an opportunity to massage the COMMAND output
    and possibly act on it in a meaningful way. For example, if COMMAND listed
    all URIs found in the current buffer, CALLBACK could validate and then open
    the selected URI in the system's default browser.

    This function is meant to be a tool to help compose the implementations of
    powerful commands that use |tlib#input#List()| as a common interface. See
    |TBrowseScriptnames| as an example.

    EXAMPLES: >
      call tlib#cmd#BrowseOutputWithCallback('tlib#cmd#ParseScriptname', 'scriptnames')
<

                                                    *tlib#cmd#DefaultBrowseOutput()*
tlib#cmd#DefaultBrowseOutput(cmd)

                                                    *tlib#cmd#ParseScriptname()*
tlib#cmd#ParseScriptname(line)

                                                    *tlib#cmd#UseVertical()*
tlib#cmd#UseVertical(?rx='')
    Look at the history whether the command was called with vertical. If 
    an rx is provided check first if the last entry in the history matches 
    this rx.

                                                    *tlib#cmd#Time()*
tlib#cmd#Time(cmd)
    Print the time in seconds or milliseconds (if your version of VIM 
    has |+reltime|) a command takes.


========================================================================
autoload/tlib/syntax.vim~

                                                    *tlib#syntax#Collect()*
tlib#syntax#Collect()

                                                    *tlib#syntax#Names()*
tlib#syntax#Names(?rx='')


========================================================================
autoload/tlib/balloon.vim~

                                                    *tlib#balloon#Register()*
tlib#balloon#Register(expr)

                                                    *tlib#balloon#Remove()*
tlib#balloon#Remove(expr)

                                                    *tlib#balloon#Expr()*
tlib#balloon#Expr()


========================================================================
autoload/tlib/vcs.vim~

                                                    *g:tlib#vcs#def*
g:tlib#vcs#def                 {...}
    A dictionarie of supported VCS (currently: git, hg, svn, bzr).

                                                    *g:tlib#vcs#executables*
g:tlib#vcs#executables         {...}
    A dictionary of custom executables for VCS commands. If the value is 
    empty, support for that VCS will be removed. If no key is present, it 
    is assumed that the VCS "type" is the name of the executable.

                                                    *g:tlib#vcs#check*
g:tlib#vcs#check               (default: has('win16') || has('win32') || has('win64') ? '%s.exe' : '%s')
    If non-empty, use it as a format string to check whether a VCS is 
    installed on your computer.

                                                    *tlib#vcs#FindVCS()*
tlib#vcs#FindVCS(filename)

                                                    *tlib#vcs#Ls()*
tlib#vcs#Ls(?filename=bufname('%'), ?vcs=[type, dir])
    Return the files under VCS.

                                                    *tlib#vcs#Diff()*
tlib#vcs#Diff(filename, ?vcs=[type, dir])
    Return the diff for "filename"


========================================================================
autoload/tlib/char.vim~

                                                    *tlib#char#Get()*
tlib#char#Get(?timeout=0)
    Get a character.

    EXAMPLES: >
      echo tlib#char#Get()
      echo tlib#char#Get(5)
<

                                                    *tlib#char#IsAvailable()*
tlib#char#IsAvailable()

                                                    *tlib#char#GetWithTimeout()*
tlib#char#GetWithTimeout(timeout, ...)


========================================================================
autoload/tlib/Filter_glob.vim~

                                                    *g:tlib#Filter_glob#seq*
g:tlib#Filter_glob#seq         (default: '*')
    A character that should be expanded to '\.\{-}'.

                                                    *g:tlib#Filter_glob#char*
g:tlib#Filter_glob#char        (default: '?')
    A character that should be expanded to '\.\?'.

                                                    *tlib#Filter_glob#New()*
tlib#Filter_glob#New(...)
    The same as |tlib#Filter_cnf#New()| but a a customizable character 
    |see tlib#Filter_glob#seq| is expanded to '\.\{-}' and 
    |g:tlib#Filter_glob#char| is expanded to '\.'.
    The pattern is a '/\V' very no-'/magic' regexp pattern.


========================================================================
autoload/tlib/scratch.vim~

                                                    *g:tlib_scratch_pos*
g:tlib_scratch_pos             (default: 'botright')
    Scratch window position. By default the list window is opened on the 
    bottom. Set this variable to 'topleft' or '' to change this behaviour.
    See |tlib#input#List()|.

                                                    *g:tlib#scratch#hidden*
g:tlib#scratch#hidden          (default: 'hide')
    If you want the scratch buffer to be fully removed, you might want to 
    set this variable to 'wipe'.
    See also https://github.com/tomtom/tlib_vim/pull/16

                                                    *tlib#scratch#UseScratch()*
tlib#scratch#UseScratch(?keyargs={})
    Display a scratch buffer (a buffer with no file). See :TScratch for an 
    example.
    Return the scratch buffer's number.
    Values for keyargs:
      scratch_split ... 1: split, 0: window, -1: tab

                                                    *tlib#scratch#CloseScratch()*
tlib#scratch#CloseScratch(keyargs, ...)
    Close a scratch buffer as defined in keyargs (usually a World).
    Return 1 if the scratch buffer is closed (or if it already was 
    closed).


========================================================================
autoload/tlib/autocmdgroup.vim~

                                                    *tlib#autocmdgroup#Init()*
tlib#autocmdgroup#Init()


========================================================================
autoload/tlib/cache.vim~

                                                    *g:tlib_cache*
g:tlib_cache                   (default: '')
    The cache directory. If empty, use |tlib#dir#MyRuntime|.'/cache'.
    You might want to delete old files from this directory from time to 
    time with a command like: >
      find ~/vimfiles/cache/ -atime +31 -type f -print -delete
<

                                                    *g:tlib#cache#purge_days*
g:tlib#cache#purge_days        (default: 31)
    |tlib#cache#Purge()|: Remove cache files older than N days.

                                                    *g:tlib#cache#purge_every_days*
g:tlib#cache#purge_every_days  (default: 31)
    Purge the cache every N days. Disable automatic purging by setting 
    this value to a negative value.

                                                    *g:tlib#cache#script_encoding*
g:tlib#cache#script_encoding   (default: &enc)
    The encoding used for the purge-cache script.
    Default: 'enc'

                                                    *g:tlib#cache#run_script*
g:tlib#cache#run_script        (default: 1)
    Whether to run the directory removal script:
       0 ... No
       1 ... Query user
       2 ... Yes

                                                    *g:tlib#cache#verbosity*
g:tlib#cache#verbosity         (default: 1)
    Verbosity level:
        0 ... Be quiet
        1 ... Display informative message
        2 ... Display detailed messages

                                                    *g:tlib#cache#dont_purge*
g:tlib#cache#dont_purge        (default: ['[\/]\.last_purge$'])
    A list of regexps that are matched against partial filenames of the 
    cached files. If a regexp matches, the file won't be removed by 
    |tlib#cache#Purge()|.

                                                    *g:tlib#cache#max_filename*
g:tlib#cache#max_filename      (default: 200)
    If the cache filename is longer than N characters, use 
    |pathshorten()|.

                                                    *tlib#cache#Dir()*
tlib#cache#Dir(?mode = 'bg')
    The default cache directory.

                                                    *tlib#cache#Filename()*
tlib#cache#Filename(type, ?file=%, ?mkdir=0, ?dir='')

                                                    *tlib#cache#Save()*
tlib#cache#Save(cfile, dictionary)

                                                    *tlib#cache#Get()*
tlib#cache#Get(cfile, ...)

                                                    *tlib#cache#Value()*
tlib#cache#Value(cfile, generator, ftime, ...)
    Get a cached value from cfile. If it is outdated (compared to ftime) 
    or does not exist, create it calling a generator function.

                                                    *tlib#cache#MaybePurge()*
tlib#cache#MaybePurge()
    Call |tlib#cache#Purge()| if the last purge was done before 
    |g:tlib#cache#purge_every_days|.

                                                    *tlib#cache#Purge()*
tlib#cache#Purge()
    Delete old files.

                                                    *tlib#cache#ListFilesInCache()*
tlib#cache#ListFilesInCache(...)


========================================================================
autoload/tlib/normal.vim~

                                                    *tlib#normal#WithRegister()*
tlib#normal#WithRegister(cmd, ?register='t', ?norm_cmd='norm!')
    Execute a normal command while maintaining all registers.


========================================================================
autoload/tlib/time.vim~

                                                    *tlib#time#MSecs()*
tlib#time#MSecs()

                                                    *tlib#time#Now()*
tlib#time#Now()

                                                    *tlib#time#Diff()*
tlib#time#Diff(a, b, ...)

                                                    *tlib#time#DiffMSecs()*
tlib#time#DiffMSecs(a, b, ...)


========================================================================
autoload/tlib/var.vim~

                                                    *tlib#var#Let()*
tlib#var#Let(name, val)
    Define a variable called NAME if yet undefined.
    You can also use the :TLLet command.

    EXAMPLES: >
      exec tlib#var#Let('g:foo', 1)
      TLet g:foo = 1
<

                                                    *tlib#var#EGet()*
tlib#var#EGet(var, namespace, ?default='')
    Retrieve a variable by searching several namespaces.

    EXAMPLES: >
      let g:foo = 1
      let b:foo = 2
      let w:foo = 3
      echo eval(tlib#var#EGet('foo', 'vg'))  => 1
      echo eval(tlib#var#EGet('foo', 'bg'))  => 2
      echo eval(tlib#var#EGet('foo', 'wbg')) => 3
<

                                                    *tlib#var#Get()*
tlib#var#Get(var, namespace, ?default='')
    Retrieve a variable by searching several namespaces.

    EXAMPLES: >
      let g:foo = 1
      let b:foo = 2
      let w:foo = 3
      echo tlib#var#Get('foo', 'bg')  => 1
      echo tlib#var#Get('foo', 'bg')  => 2
      echo tlib#var#Get('foo', 'wbg') => 3
<

                                                    *tlib#var#List()*
tlib#var#List(rx, ?prefix='')
    Get a list of variables matching rx.
    EXAMPLE:
      echo tlib#var#List('tlib_', 'g:')


========================================================================
autoload/tlib/agent.vim~
Various agents for use as key handlers in tlib#input#List()

                                                    *g:tlib_scroll_lines*
g:tlib_scroll_lines            (default: 10)
    Number of items to move when pressing <c-up/down> in the input list window.

                                                    *tlib#agent#Exit()*
tlib#agent#Exit(world, selected)

                                                    *tlib#agent#CopyItems()*
tlib#agent#CopyItems(world, selected)

                                                    *tlib#agent#PageUp()*
tlib#agent#PageUp(world, selected)

                                                    *tlib#agent#PageDown()*
tlib#agent#PageDown(world, selected)

                                                    *tlib#agent#Home()*
tlib#agent#Home(world, selected)

                                                    *tlib#agent#End()*
tlib#agent#End(world, selected)

                                                    *tlib#agent#Up()*
tlib#agent#Up(world, selected, ...)

                                                    *tlib#agent#Down()*
tlib#agent#Down(world, selected, ...)

                                                    *tlib#agent#UpN()*
tlib#agent#UpN(world, selected)

                                                    *tlib#agent#DownN()*
tlib#agent#DownN(world, selected)

                                                    *tlib#agent#ShiftLeft()*
tlib#agent#ShiftLeft(world, selected)

                                                    *tlib#agent#ShiftRight()*
tlib#agent#ShiftRight(world, selected)

                                                    *tlib#agent#Reset()*
tlib#agent#Reset(world, selected)

                                                    *tlib#agent#ToggleRestrictView()*
tlib#agent#ToggleRestrictView(world, selected)

                                                    *tlib#agent#RestrictView()*
tlib#agent#RestrictView(world, selected)

                                                    *tlib#agent#UnrestrictView()*
tlib#agent#UnrestrictView(world, selected)

                                                    *tlib#agent#Input()*
tlib#agent#Input(world, selected)

                                                    *tlib#agent#SuspendToParentWindow()*
tlib#agent#SuspendToParentWindow(world, selected)
    Suspend (see |tlib#agent#Suspend|) the input loop and jump back to the 
    original position in the parent window.

                                                    *tlib#agent#Suspend()*
tlib#agent#Suspend(world, selected)
    Suspend lets you temporarily leave the input loop of 
    |tlib#input#List|. You can resume editing the list by pressing <c-z>, 
    <m-z>. <space>, <c-LeftMouse> or <MiddleMouse> in the suspended window.
    <cr> and <LeftMouse> will immediatly select the item under the cursor.
    < will select the item but the window will remain opened.

                                                    *tlib#agent#Help()*
tlib#agent#Help(world, selected)

                                                    *tlib#agent#OR()*
tlib#agent#OR(world, selected)

                                                    *tlib#agent#AND()*
tlib#agent#AND(world, selected)

                                                    *tlib#agent#ReduceFilter()*
tlib#agent#ReduceFilter(world, selected)

                                                    *tlib#agent#PopFilter()*
tlib#agent#PopFilter(world, selected)

                                                    *tlib#agent#Debug()*
tlib#agent#Debug(world, selected)

                                                    *tlib#agent#Select()*
tlib#agent#Select(world, selected)

                                                    *tlib#agent#SelectUp()*
tlib#agent#SelectUp(world, selected)

                                                    *tlib#agent#SelectDown()*
tlib#agent#SelectDown(world, selected)

                                                    *tlib#agent#SelectAll()*
tlib#agent#SelectAll(world, selected)

                                                    *tlib#agent#ToggleStickyList()*
tlib#agent#ToggleStickyList(world, selected)

                                                    *tlib#agent#EditItem()*
tlib#agent#EditItem(world, selected)

                                                    *tlib#agent#NewItem()*
tlib#agent#NewItem(world, selected)
    Insert a new item below the current one.

                                                    *tlib#agent#DeleteItems()*
tlib#agent#DeleteItems(world, selected)

                                                    *tlib#agent#Cut()*
tlib#agent#Cut(world, selected)

                                                    *tlib#agent#Copy()*
tlib#agent#Copy(world, selected)

                                                    *tlib#agent#Paste()*
tlib#agent#Paste(world, selected)

                                                    *tlib#agent#EditReturnValue()*
tlib#agent#EditReturnValue(world, rv)

                                                    *tlib#agent#ViewFile()*
tlib#agent#ViewFile(world, selected)

                                                    *tlib#agent#EditFile()*
tlib#agent#EditFile(world, selected)

                                                    *tlib#agent#EditFileInSplit()*
tlib#agent#EditFileInSplit(world, selected)

                                                    *tlib#agent#EditFileInVSplit()*
tlib#agent#EditFileInVSplit(world, selected)

                                                    *tlib#agent#EditFileInTab()*
tlib#agent#EditFileInTab(world, selected)

                                                    *tlib#agent#ToggleScrollbind()*
tlib#agent#ToggleScrollbind(world, selected)

                                                    *tlib#agent#ShowInfo()*
tlib#agent#ShowInfo(world, selected)

                                                    *tlib#agent#PreviewLine()*
tlib#agent#PreviewLine(world, selected)

                                                    *tlib#agent#GotoLine()*
tlib#agent#GotoLine(world, selected)
    If not called from the scratch, we assume/guess that we don't have to 
    suspend the input-evaluation loop.

                                                    *tlib#agent#DoAtLine()*
tlib#agent#DoAtLine(world, selected)

                                                    *tlib#agent#Wildcard()*
tlib#agent#Wildcard(world, selected)

                                                    *tlib#agent#Null()*
tlib#agent#Null(world, selected)

                                                    *tlib#agent#ExecAgentByName()*
tlib#agent#ExecAgentByName(world, selected)

                                                    *tlib#agent#CompleteAgentNames()*
tlib#agent#CompleteAgentNames(ArgLead, CmdLine, CursorPos)


========================================================================
autoload/tlib/bitwise.vim~

                                                    *tlib#bitwise#Num2Bits()*
tlib#bitwise#Num2Bits(num)

                                                    *tlib#bitwise#Bits2Num()*
tlib#bitwise#Bits2Num(bits, ...)

                                                    *tlib#bitwise#AND()*
tlib#bitwise#AND(num1, num2, ...)

                                                    *tlib#bitwise#OR()*
tlib#bitwise#OR(num1, num2, ...)

                                                    *tlib#bitwise#XOR()*
tlib#bitwise#XOR(num1, num2, ...)

                                                    *tlib#bitwise#ShiftRight()*
tlib#bitwise#ShiftRight(bits, n)

                                                    *tlib#bitwise#ShiftLeft()*
tlib#bitwise#ShiftLeft(bits, n)

                                                    *tlib#bitwise#Add()*
tlib#bitwise#Add(num1, num2, ...)

                                                    *tlib#bitwise#Sub()*
tlib#bitwise#Sub(num1, num2, ...)


========================================================================
autoload/tlib/url.vim~

                                                    *tlib#url#Decode()*
tlib#url#Decode(url)
    Decode an encoded URL.

                                                    *tlib#url#DecodeChar()*
tlib#url#DecodeChar(char)
    Decode a single character.

                                                    *tlib#url#EncodeChar()*
tlib#url#EncodeChar(char)
    Encode a single character.

                                                    *tlib#url#Encode()*
tlib#url#Encode(url, ...)
    Encode an URL.


========================================================================
autoload/tlib/signs.vim~

                                                    *tlib#signs#ClearAll()*
tlib#signs#ClearAll(sign)
    Clear all signs with name SIGN.

                                                    *tlib#signs#ClearBuffer()*
tlib#signs#ClearBuffer(sign, bufnr)
    Clear all signs with name SIGN in buffer BUFNR.

                                                    *tlib#signs#Mark()*
tlib#signs#Mark(sign, list)
    Add signs for all locations in LIST. LIST must adhere with the 
    quickfix list format (see |getqflist()|; only the fields lnum and 
    bufnr are required).

    list:: a quickfix or location list
    sign:: a sign defined with |:sign-define|


========================================================================
autoload/tlib/rx.vim~

                                                    *tlib#rx#Escape()*
tlib#rx#Escape(text, ?magic='m')
    magic can be one of: m, M, v, V
    See :help 'magic'

                                                    *tlib#rx#EscapeReplace()*
tlib#rx#EscapeReplace(text, ?magic='m')
    Escape return |sub-replace-special|.

                                                    *tlib#rx#Suffixes()*
tlib#rx#Suffixes(...)


========================================================================
autoload/tlib/tag.vim~

                                                    *g:tlib_tags_extra*
g:tlib_tags_extra              (default: '')
    Extra tags for |tlib#tag#Retrieve()| (see there). Can also be buffer-local.

                                                    *g:tlib_tag_substitute*
g:tlib_tag_substitute
    Filter the tag description through |substitute()| for these filetypes. 
    This applies only if the tag cmd field (see |taglist()|) is used.

                                                    *tlib#tag#Retrieve()*
tlib#tag#Retrieve(rx, ?extra_tags=0)
    Get all tags matching rx. Basically, this function simply calls 
    |taglist()|, but when extra_tags is true, the list of the tag files 
    (see 'tags') is temporarily expanded with |g:tlib_tags_extra|.

    Example use:
    If you want to include tags for, eg, JDK, normal tags use can become 
    slow. You could proceed as follows:
        1. Create a tags file for the JDK sources. When creating the tags 
        file, make sure to include inheritance information and the like 
        (command-line options like --fields=+iaSm --extra=+q should be ok).
        In this example, we want tags only for public methods (there are 
        most likely better ways to do this): >
             ctags -R --fields=+iaSm --extra=+q ${JAVA_HOME}/src
             head -n 6 tags > tags0
             grep access:public tags >> tags0
<      2. Make 'tags' include project specific tags files. In 
         ~/vimfiles/after/ftplugin/java.vim insert: >
             let b:tlib_tags_extra = $JAVA_HOME .'/tags0'
<      3. When this function is invoked as >
             echo tlib#tag#Retrieve('print')
<      it will return only project-local tags. If it is invoked as >
             echo tlib#tag#Retrieve('print', 1)
<      tags from the JDK will be included.

                                                    *tlib#tag#Collect()*
tlib#tag#Collect(constraints, ?use_extra=1, ?match_front=1)
    Retrieve tags that meet the constraints (a dictionnary of fields and 
    regexp, with the exception of the kind field which is a list of chars). 
    For the use of the optional use_extra argument see 
    |tlib#tag#Retrieve()|.

                                                    *tlib#tag#Format()*
tlib#tag#Format(tag)


========================================================================
autoload/tlib/map.vim~

                                                    *tlib#map#PumAccept()*
tlib#map#PumAccept(key)
    If |pumvisible()| is true, return "\<c-y>". Otherwise return a:key.
    For use in maps like: >
      imap <expr> <cr> tlib#map#PumAccept("\<cr>")
<


========================================================================
autoload/tlib/Filter_cnfd.vim~

                                                    *tlib#Filter_cnfd#New()*
tlib#Filter_cnfd#New(...)
    The same as |tlib#Filter_cnf#New()| but a dot is expanded to '\.\{-}'. 
    As a consequence, patterns cannot match dots.
    The pattern is a '/\V' very no-'/magic' regexp pattern.


========================================================================
autoload/tlib/input.vim~
Input-related, select from a list etc.

                                                    *g:tlib#input#sortprefs_threshold*
g:tlib#input#sortprefs_threshold (default: 200)
    If a list is bigger than this value, don't try to be smart when 
    selecting an item. Be slightly faster instead.
    See |tlib#input#List()|.

                                                    *g:tlib#input#livesearch_threshold*
g:tlib#input#livesearch_threshold (default: 1000)
    If a list contains more items, |tlib#input#List()| does not perform an 
    incremental "live search" but uses |input()| to query the user for a 
    filter. This is useful on slower machines or with very long lists.

                                                    *g:tlib#input#filter_mode*
g:tlib#input#filter_mode       (default: 'glob')
    Determine how |tlib#input#List()| and related functions work.
    Can be "glob", "cnf", "cnfd", "seq", or "fuzzy". See:
      glob ... Like cnf but "*" and "?" (see |g:tlib#Filter_glob#seq|, 
          |g:tlib#Filter_glob#char|) are interpreted as glob-like 
          |wildcards| (this is the default method)
        - Examples:
            - "f*o" matches "fo", "fxo", and "fxxxoo", but doesn't match 
              "far".
        - Otherwise it is a derivate of the cnf method (see below).
        - See also |tlib#Filter_glob#New()|.
      cnfd ... Like cnf but "." is interpreted as a wildcard, i.e. it is 
               expanded to "\.\{-}"
        - A period character (".") acts as a wildcard as if ".\{-}" (see 
          |/\{-|) were entered.
        - Examples:
            - "f.o" matches "fo", "fxo", and "fxxxoo", but doesn't match 
              "far".
        - Otherwise it is a derivate of the cnf method (see below).
        - See also |tlib#Filter_cnfd#New()|.
      cnf .... Match substrings
        - A blank creates an AND conjunction, i.e. the next pattern has to 
          match too.
        - A pipe character ("|") creates an OR conjunction, either this or 
          the next next pattern has to match.
        - Patterns are very 'nomagic' |regexp| with a |\V| prefix.
        - A pattern starting with "-" makes the filter exclude items 
          matching that pattern.
        - Examples:
            - "foo bar" matches items that contain the strings "foo" AND 
              "bar".
            - "foo|bar boo|far" matches items that contain either ("foo" OR 
              "bar") AND ("boo" OR "far").
        - See also |tlib#Filter_cnf#New()|.
      seq .... Match sequences of characters
        - |tlib#Filter_seq#New()|
      fuzzy .. Match fuzzy character sequences
        - |tlib#Filter_fuzzy#New()|

                                                    *g:tlib#input#higroup*
g:tlib#input#higroup           (default: 'IncSearch')
    The highlight group to use for showing matches in the input list 
    window.
    See |tlib#input#List()|.

                                                    *g:tlib_pick_last_item*
g:tlib_pick_last_item          (default: 1)
    When 1, automatically select the last remaining item only if the list 
    had only one item to begin with.
    When 2, automatically select a last remaining item after applying 
    any filters.
    See |tlib#input#List()|.


Keys for |tlib#input#List|~

                                                    *g:tlib#input#and*
g:tlib#input#and               (default: ' ')

                                                    *g:tlib#input#or*
g:tlib#input#or                (default: '|')

                                                    *g:tlib#input#not*
g:tlib#input#not               (default: '-')

                                                    *g:tlib#input#numeric_chars*
g:tlib#input#numeric_chars
    When editing a list with |tlib#input#List|, typing these numeric chars 
    (as returned by getchar()) will select an item based on its index, not 
    based on its name. I.e. in the default setting, typing a "4" will 
    select the fourth item, not the item called "4".
    In order to make keys 0-9 filter the items in the list and make 
    <m-[0-9]> select an item by its index, remove the keys 48 to 57 from 
    this dictionary.
    Format: [KEY] = BASE ... the number is calculated as KEY - BASE.

                                                    *g:tlib#input#keyagents_InputList_s*
g:tlib#input#keyagents_InputList_s
    The default key bindings for single-item-select list views. If you 
    want to use <c-j>, <c-k> to move the cursor up and down, add these two 
    lines to after/plugin/02tlib.vim: >

      let g:tlib#input#keyagents_InputList_s[10] = 'tlib#agent#Down'  " <c-j>
      let g:tlib#input#keyagents_InputList_s[11] = 'tlib#agent#Up'    " <c-k>
<

                                                    *g:tlib#input#keyagents_InputList_m*
g:tlib#input#keyagents_InputList_m

                                                    *g:tlib#input#handlers_EditList*
g:tlib#input#handlers_EditList

                                                    *g:tlib#input#use_popup*
g:tlib#input#use_popup         (default: has('menu') && (has('gui_gtk') || has('gui_gtk2') || has('gui_win32')))
    If true, define a popup menu for |tlib#input#List()| and related 
    functions.

                                                    *g:tlib#input#format_filename*
g:tlib#input#format_filename   (default: 'l')
    How to format filenames:
        l ... Show basenames on the left side, separated from the 
              directory names
        r ... Show basenames on the right side

                                                    *g:tlib#input#filename_padding_r*
g:tlib#input#filename_padding_r (default: '&co / 10')
    If g:tlib#input#format_filename == 'r', how much space should be kept 
    free on the right side.

                                                    *g:tlib#input#filename_max_width*
g:tlib#input#filename_max_width (default: '&co / 2')
    If g:tlib#input#format_filename == 'l', an expression that 
    |eval()|uates to the maximum display width of filenames.

                                                    *tlib#input#List()*
tlib#input#List(type. ?query='', ?list=[], ?handlers=[], ?default="", ?timeout=0)
    Select a single or multiple items from a list. Return either the list 
    of selected elements or its indexes.

    By default, typing numbers will select an item by its index. See 
    |g:tlib#input#numeric_chars| to find out how to change this.

    The item is automatically selected if the numbers typed equals the 
    number of digits of the list length. I.e. if a list contains 20 items, 
    typing 1 will first highlight item 1 but it won't select/use it 
    because 1 is an ambiguous input in this context. If you press enter, 
    the first item will be selected. If you press another digit (e.g. 0), 
    item 10 will be selected. Another way to select item 1 would be to 
    type 01. If the list contains only 9 items, typing 1 would select the 
    first item right away.

    type can be:
        s  ... Return one selected element
        si ... Return the index of the selected element
        m  ... Return a list of selected elements
        mi ... Return a list of indexes

    Several pattern matching styles are supported. See 
    |g:tlib#input#filter_mode|.

    EXAMPLES: >
      echo tlib#input#List('s', 'Select one item', [100,200,300])
      echo tlib#input#List('si', 'Select one item', [100,200,300])
      echo tlib#input#List('m', 'Select one or more item(s)', [100,200,300])
      echo tlib#input#List('mi', 'Select one or more item(s)', [100,200,300])

<   See ../samples/tlib/input/tlib_input_list.vim (move the cursor over 
    the filename and press gf) for a more elaborated example.

                                                    *tlib#input#ListD()*
tlib#input#ListD(dict)
    A wrapper for |tlib#input#ListW()| that builds |tlib#World#New| from 
    dict.

                                                    *tlib#input#ListW()*
tlib#input#ListW(world, ?command='')
    The second argument (command) is meant for internal use only.
    The same as |tlib#input#List| but the arguments are packed into world 
    (an instance of tlib#World as returned by |tlib#World#New|).

                                                    *tlib#input#EditList()*
tlib#input#EditList(query, list, ?timeout=0)
    Edit a list.

    EXAMPLES: >
      echo tlib#input#EditList('Edit:', [100,200,300])
<

                                                    *tlib#input#Resume()*
tlib#input#Resume(name, pick, bufnr)

                                                    *tlib#input#CommandSelect()*
tlib#input#CommandSelect(command, ?keyargs={})
    Take a command, view the output, and let the user select an item from 
    its output.

    EXAMPLE: >
        command! TMarks exec 'norm! `'. matchstr(tlib#input#CommandSelect('marks'), '^ \+\zs.')
        command! TAbbrevs exec 'norm i'. matchstr(tlib#input#CommandSelect('abbrev'), '^\S\+\s\+\zs\S\+')
<

                                                    *tlib#input#Edit()*
tlib#input#Edit(name, value, callback, ?cb_args=[])

    Edit a value (asynchronously) in a scratch buffer. Use name for 
    identification. Call callback when done (or on cancel).
    In the scratch buffer:
    Press <c-s> or <c-w><cr> to enter the new value, <c-w>c to cancel 
    editing.
    EXAMPLES: >
      fun! FooContinue(success, text)
          if a:success
              let b:var = a:text
          endif
      endf
      call tlib#input#Edit('foo', b:var, 'FooContinue')
<

                                                    *tlib#input#Dialog()*
tlib#input#Dialog(text, options, default)


========================================================================
autoload/tlib/number.vim~

                                                    *tlib#number#ConvertBase()*
tlib#number#ConvertBase(num, base, ...)


========================================================================
autoload/tlib/file.vim~

                                                    *tlib#file#Split()*
tlib#file#Split(filename)
    EXAMPLES: >
      tlib#file#Split('foo/bar/filename.txt')
      => ['foo', 'bar', 'filename.txt']
<

                                                    *tlib#file#Join()*
tlib#file#Join(filename_parts, ?strip_slashes=1)
    EXAMPLES: >
      tlib#file#Join(['foo', 'bar', 'filename.txt'])
      => 'foo/bar/filename.txt'
<

                                                    *tlib#file#Relative()*
tlib#file#Relative(filename, basedir)
    EXAMPLES: >
      tlib#file#Relative('foo/bar/filename.txt', 'foo')
      => 'bar/filename.txt'
<

                                                    *tlib#file#Absolute()*
tlib#file#Absolute(filename, ...)

                                                    *tlib#file#With()*
tlib#file#With(fcmd, bcmd, files, ?world={})


========================================================================
autoload/tlib/paragraph.vim~

                                                    *tlib#paragraph#GetMetric()*
tlib#paragraph#GetMetric()
    Return an object describing a |paragraph|.

                                                    *tlib#paragraph#Move()*
tlib#paragraph#Move(direction, count)
    This function can be used with the tinymode plugin to move around 
    paragraphs.

    Example configuration: >

      call tinymode#EnterMap("para_move", "gp")
      call tinymode#ModeMsg("para_move", "Move paragraph: j/k")
      call tinymode#Map("para_move", "j", "silent call tlib#paragraph#Move('Down', '[N]')")
      call tinymode#Map("para_move", "k", "silent call tlib#paragraph#Move('Up', '[N]')")
      call tinymode#ModeArg("para_move", "owncount", 1)
<


========================================================================
autoload/tlib/World.vim~
A prototype used by |tlib#input#List|.
Inherits from |tlib#Object#New|.

                                                    *g:tlib_inputlist_pct*
g:tlib_inputlist_pct           (default: 50)
    Size of the input list window (in percent) from the main size (of &lines).
    See |tlib#input#List()|.

                                                    *g:tlib_inputlist_width_filename*
g:tlib_inputlist_width_filename (default: '&co / 3')
    Size of filename columns when listing filenames.
    See |tlib#input#List()|.

                                                    *g:tlib_inputlist_filename_indicators*
g:tlib_inputlist_filename_indicators (default: 0)
    If true, |tlib#input#List()| will show some indicators about the 
    status of a filename (e.g. buflisted(), bufloaded() etc.).
    This is disabled by default because vim checks also for the file on 
    disk when doing this.

                                                    *g:tlib_inputlist_shortmessage*
g:tlib_inputlist_shortmessage  (default: 0)
    If not null, display only a short info about the filter.

                                                    *tlib#World#New()*
tlib#World#New(...)

prototype.PrintLines

prototype.Suspend


========================================================================
autoload/tlib/tab.vim~

                                                    *tlib#tab#BufMap()*
tlib#tab#BufMap()
    Return a dictionary of bufnumbers => [[tabpage, winnr] ...]

                                                    *tlib#tab#TabWinNr()*
tlib#tab#TabWinNr(buffer)
    Find a buffer's window at some tab page.

                                                    *tlib#tab#Set()*
tlib#tab#Set(tabnr)


========================================================================
autoload/tlib/date.vim~

                                                    *tlib#date#DiffInDays()*
tlib#date#DiffInDays(date1, ?date2=localtime(), ?allow_zero=0)

                                                    *tlib#date#Parse()*
tlib#date#Parse(date, ?allow_zero=0) "{{{3

                                                    *tlib#date#SecondsSince1970()*
tlib#date#SecondsSince1970(date, ...)
    tlib#date#SecondsSince1970(date, ?daysshift=0, ?allow_zero=0)


========================================================================
autoload/tlib/type.vim~

                                                    *tlib#type#IsNumber()*
tlib#type#IsNumber(expr)

                                                    *tlib#type#IsString()*
tlib#type#IsString(expr)

                                                    *tlib#type#IsFuncref()*
tlib#type#IsFuncref(expr)

                                                    *tlib#type#IsList()*
tlib#type#IsList(expr)

                                                    *tlib#type#IsDictionary()*
tlib#type#IsDictionary(expr)


========================================================================
autoload/tlib/Filter_fuzzy.vim~

                                                    *tlib#Filter_fuzzy#New()*
tlib#Filter_fuzzy#New(...)
    Support for "fuzzy" pattern matching in |tlib#input#List()|. 
    Patterns are interpreted as if characters were connected with '.\{-}'.

    In "fuzzy" mode, the pretty printing of filenames is disabled.


========================================================================
autoload/tlib/textobjects.vim~

                                                    *standard-paragraph*
tlib#textobjects#StandardParagraph()
    Select a "Standard Paragraph", i.e. a text block followed by blank 
    lines. Other than |ap|, the last paragraph in a document is handled 
    just the same.

    The |text-object| can be accessed as "sp". Example: >

      vsp ... select the current standard paragraph

<   Return 1, if the paragraph is the last one in the document.

                                                    *tlib#textobjects#Init()*
tlib#textobjects#Init()

                                                    *v_sp*
v_sp ... <Esc>:call tlib#textobjects#StandardParagraph()<CR>
    sp ... Standard paragraph (for use as |text-objects|).

                                                    *o_sp*
o_sp ... :<C-u>normal Vsp<CR>


========================================================================
autoload/tlib/arg.vim~

                                                    *tlib#arg#Get()*
tlib#arg#Get(n, var, ?default="", ?test='')
    Set a positional argument from a variable argument list.
    See tlib#string#RemoveBackslashes() for an example.

                                                    *tlib#arg#Let()*
tlib#arg#Let(list, ?default='')
    Set a positional arguments from a variable argument list.
    See tlib#input#List() for an example.

                                                    *tlib#arg#Key()*
tlib#arg#Key(dict, list, ?default='')
    See |:TKeyArg|.

                                                    *tlib#arg#StringAsKeyArgs()*
tlib#arg#StringAsKeyArgs(string, ?keys=[], ?evaluate=0)

                                                    *tlib#arg#Ex()*
tlib#arg#Ex(arg, ?chars='%#! ')
    Escape some characters in a string.

    Use |fnamescape()| if available.

    EXAMPLES: >
      exec 'edit '. tlib#arg#Ex('foo%#bar.txt')
<


========================================================================
autoload/tlib/fixes.vim~

                                                    *tlib#fixes#Winpos()*
tlib#fixes#Winpos()


========================================================================
autoload/tlib/dir.vim~

                                                    *g:tlib#dir#sep*
g:tlib#dir#sep                 (default: exists('+shellslash') && !&shellslash ? '\' : '/')
    TLet g:tlib#dir#sep = '/'

                                                    *tlib#dir#CanonicName()*
tlib#dir#CanonicName(dirname)
    EXAMPLES: >
      tlib#dir#CanonicName('foo/bar')
      => 'foo/bar/'
<

                                                    *tlib#dir#NativeName()*
tlib#dir#NativeName(dirname)
    EXAMPLES: >
      tlib#dir#NativeName('foo/bar/')
      On Windows:
      => 'foo\bar\'
      On Linux:
      => 'foo/bar/'
<

                                                    *tlib#dir#PlainName()*
tlib#dir#PlainName(dirname)
    EXAMPLES: >
      tlib#dir#PlainName('foo/bar/')
      => 'foo/bar'
<

                                                    *tlib#dir#Ensure()*
tlib#dir#Ensure(dir)
    Create a directory if it doesn't already exist.

                                                    *tlib#dir#MyRuntime()*
tlib#dir#MyRuntime()
    Return the first directory in &rtp.

                                                    *tlib#dir#CD()*
tlib#dir#CD(dir, ?locally=0)

                                                    *tlib#dir#Push()*
tlib#dir#Push(dir, ?locally=0)

                                                    *tlib#dir#Pop()*
tlib#dir#Pop()


========================================================================
autoload/tlib/hash.vim~

                                                    *g:tlib#hash#use_crc32*
g:tlib#hash#use_crc32          (default: '')

                                                    *g:tlib#hash#use_adler32*
g:tlib#hash#use_adler32        (default: '')

                                                    *tlib#hash#CRC32B()*
tlib#hash#CRC32B(chars)

                                                    *tlib#hash#CRC32B_ruby()*
tlib#hash#CRC32B_ruby(chars)

                                                    *tlib#hash#CRC32B_vim()*
tlib#hash#CRC32B_vim(chars)

                                                    *tlib#hash#Adler32()*
tlib#hash#Adler32(chars)

                                                    *tlib#hash#Adler32_vim()*
tlib#hash#Adler32_vim(chars)

                                                    *tlib#hash#Adler32_tlib()*
tlib#hash#Adler32_tlib(chars)


========================================================================
autoload/tlib/win.vim~

                                                    *tlib#win#Set()*
tlib#win#Set(winnr)
    Return vim code to jump back to the original window.

                                                    *tlib#win#GetLayout()*
tlib#win#GetLayout(?save_view=0)

                                                    *tlib#win#SetLayout()*
tlib#win#SetLayout(layout)

                                                    *tlib#win#List()*
tlib#win#List()

                                                    *tlib#win#Width()*
tlib#win#Width(wnr)

                                                    *tlib#win#WinDo()*
tlib#win#WinDo(ex)


========================================================================
autoload/tlib/comments.vim~

                                                    *tlib#comments#Comments()*
tlib#comments#Comments(...)
    function! tlib#comments#Comments(?rx='')


========================================================================
autoload/tlib/grep.vim~

                                                    *tlib#grep#Do()*
tlib#grep#Do(cmd, rx, files)

                                                    *tlib#grep#LocList()*
tlib#grep#LocList(rx, files)

                                                    *tlib#grep#QuickFixList()*
tlib#grep#QuickFixList(rx, files)

                                                    *tlib#grep#List()*
tlib#grep#List(rx, files)


========================================================================
autoload/tlib/Filter_cnf.vim~

                                                    *tlib#Filter_cnf#New()*
tlib#Filter_cnf#New(...)
    The search pattern for |tlib#input#List()| is in conjunctive normal 
    form: (P1 OR P2 ...) AND (P3 OR P4 ...) ...
    The pattern is a '/\V' very no-'/magic' regexp pattern.

    Pressing <space> joins two patterns with AND.
    Pressing | joins two patterns with OR.
    I.e. In order to get "lala AND (foo OR bar)", you type 
    "lala foo|bar".

    This is also the base class for other filters.

prototype.Pretty


========================================================================
autoload/tlib/Object.vim~
Provides a prototype plus some OO-like methods.

                                                    *tlib#Object#New()*
tlib#Object#New(?fields={})
    This function creates a prototype that provides some kind of 
    inheritance mechanism and a way to call parent/super methods.

    The usage demonstrated in the following example works best when every 
    class/prototype is defined in a file of its own.

    The reason for why there is a dedicated constructor function is that 
    this layout facilitates the use of templates and that methods are 
    hidden from the user. Other solutions are possible.

    EXAMPLES: >
        let s:prototype = tlib#Object#New({
                    \ '_class': ['FooBar'],
                    \ 'foo': 1, 
                    \ 'bar': 2, 
                    \ })
        " Constructor
        function! FooBar(...)
            let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
            return object
        endf
        function! s:prototype.babble() {
          echo "I think, therefore I am ". (self.foo * self.bar) ." months old."
        }

<   This could now be used like this: >
        let myfoo = FooBar({'foo': 3})
        call myfoo.babble()
        => I think, therefore I am 6 months old.
        echo myfoo.IsA('FooBar')
        => 1
        echo myfoo.IsA('object')
        => 1
        echo myfoo.IsA('Foo')
        => 0
        echo myfoo.RespondTo('babble')
        => 1
        echo myfoo.RespondTo('speak')
        => 0
<

prototype.New

prototype.Inherit

prototype.Extend

prototype.IsA

prototype.IsRelated

prototype.RespondTo

prototype.Super

                                                    *tlib#Object#Methods()*
tlib#Object#Methods(object, ...)


========================================================================
autoload/tlib/buffer.vim~

                                                    *g:tlib_viewline_position*
g:tlib_viewline_position       (default: 'zz')
    Where to display the line when using |tlib#buffer#ViewLine|.
    For possible values for position see |scroll-cursor|.

                                                    *tlib#buffer#EnableMRU()*
tlib#buffer#EnableMRU()

                                                    *tlib#buffer#DisableMRU()*
tlib#buffer#DisableMRU()

                                                    *tlib#buffer#Set()*
tlib#buffer#Set(buffer)
    Set the buffer to buffer and return a command as string that can be 
    evaluated by |:execute| in order to restore the original view.

                                                    *tlib#buffer#Eval()*
tlib#buffer#Eval(buffer, code)
    Evaluate CODE in BUFFER.

    EXAMPLES: >
      call tlib#buffer#Eval('foo.txt', 'echo b:bar')
<

                                                    *tlib#buffer#GetList()*
tlib#buffer#GetList(?show_hidden=0, ?show_number=0, " ?order='bufnr')
    Possible values for the "order" argument:
      bufnr    :: Default behaviour
      mru      :: Sort buffers according to most recent use
      basename :: Sort by the file's basename (last component)

    NOTE: MRU order works on second invocation only. If you want to always 
    use MRU order, call tlib#buffer#EnableMRU() in your ~/.vimrc file.

                                                    *tlib#buffer#ViewLine()*
tlib#buffer#ViewLine(line, ?position='z')
    line is either a number or a string that begins with a number.
    For possible values for position see |scroll-cursor|.
    See also |g:tlib_viewline_position|.

                                                    *tlib#buffer#HighlightLine()*
tlib#buffer#HighlightLine(...)

                                                    *tlib#buffer#DeleteRange()*
tlib#buffer#DeleteRange(line1, line2)
    Delete the lines in the current buffer. Wrapper for |:delete|.

                                                    *tlib#buffer#ReplaceRange()*
tlib#buffer#ReplaceRange(line1, line2, lines)
    Replace a range of lines.

                                                    *tlib#buffer#ScratchStart()*
tlib#buffer#ScratchStart()
    Initialize some scratch area at the bottom of the current buffer.

                                                    *tlib#buffer#ScratchEnd()*
tlib#buffer#ScratchEnd()
    Remove the in-buffer scratch area.

                                                    *tlib#buffer#BufDo()*
tlib#buffer#BufDo(exec)
    Run exec on all buffers via bufdo and return to the original buffer.

                                                    *tlib#buffer#InsertText()*
tlib#buffer#InsertText(text, keyargs)
    Keyargs:
      'shift': 0|N
      'col': col('.')|N
      'lineno': line('.')|N
      'indent': 0|1
      'pos': 'e'|'s' ... Where to locate the cursor (somewhat like s and e in {offset})
    Insert text (a string) in the buffer.

                                                    *tlib#buffer#InsertText0()*
tlib#buffer#InsertText0(text, ...)

                                                    *tlib#buffer#CurrentByte()*
tlib#buffer#CurrentByte()

                                                    *tlib#buffer#KeepCursorPosition()*
tlib#buffer#KeepCursorPosition(cmd)
    Evaluate cmd while maintaining the cursor position and jump registers.


========================================================================
autoload/tlib/hook.vim~

                                                    *tlib#hook#Run()*
tlib#hook#Run(hook, ?dict={})
    Execute dict[hook], w:{hook}, b:{hook}, or g:{hook} if existent.


========================================================================
autoload/tlib/string.vim~

                                                    *tlib#string#RemoveBackslashes()*
tlib#string#RemoveBackslashes(text, ?chars=' ')
    Remove backslashes from text (but only in front of the characters in 
    chars).

                                                    *tlib#string#Chomp()*
tlib#string#Chomp(string)

                                                    *tlib#string#Format()*
tlib#string#Format(template, dict)

                                                    *tlib#string#Printf1()*
tlib#string#Printf1(format, string)
    This function deviates from |printf()| in certain ways.
    Additional items:
        %{rx}      ... insert escaped regexp
        %{fuzzyrx} ... insert typo-tolerant regexp

                                                    *tlib#string#TrimLeft()*
tlib#string#TrimLeft(string)

                                                    *tlib#string#TrimRight()*
tlib#string#TrimRight(string)

                                                    *tlib#string#Strip()*
tlib#string#Strip(string)

                                                    *tlib#string#Count()*
tlib#string#Count(string, rx)



vim:tw=78:fo=tcq2:isk=!-~,^*,^|,^":ts=8:ft=help:norl:
test/tlib.vim	[[[1
219
" tLib.vim
" @Author:      Thomas Link (mailto:micathom AT gmail com?subject=vim-tLib)
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2006-12-17.
" @Last Change: 2008-11-23.
" @Revision:    129

if !exists("loaded_tassert")
    echoerr 'tAssert (vimscript #1730) is required'
endif


TAssertBegin! "tlib"


" List {{{2
fun! Add(a,b)
    return a:a + a:b
endf
TAssert IsEqual(tlib#list#Inject([], 0, function('Add')), 0)
TAssert IsEqual(tlib#list#Inject([1,2,3], 0, function('Add')), 6)
delfunction Add

TAssert IsEqual(tlib#list#Compact([]), [])
TAssert IsEqual(tlib#list#Compact([0,1,2,3,[], {}, ""]), [1,2,3])

TAssert IsEqual(tlib#list#Flatten([]), [])
TAssert IsEqual(tlib#list#Flatten([1,2,3]), [1,2,3])
TAssert IsEqual(tlib#list#Flatten([1,2, [1,2,3], 3]), [1,2,1,2,3,3])
TAssert IsEqual(tlib#list#Flatten([0,[1,2,[3,""]]]), [0,1,2,3,""])

TAssert IsEqual(tlib#list#FindAll([1,2,3], 'v:val >= 2'), [2,3])
TAssert IsEqual(tlib#list#FindAll([1,2,3], 'v:val >= 2', 'v:val * 10'), [20,30])

TAssert IsEqual(tlib#list#Find([1,2,3], 'v:val >= 2'), 2)
TAssert IsEqual(tlib#list#Find([1,2,3], 'v:val >= 2', 0, 'v:val * 10'), 20)
TAssert IsEqual(tlib#list#Find([1,2,3], 'v:val >= 5', 10), 10)

TAssert IsEqual(tlib#list#Any([1,2,3], 'v:val >= 2'), 1)
TAssert IsEqual(tlib#list#Any([1,2,3], 'v:val >= 5'), 0)

TAssert IsEqual(tlib#list#All([1,2,3], 'v:val < 5'), 1)
TAssert IsEqual(tlib#list#All([1,2,3], 'v:val >= 2'), 0)

TAssert IsEqual(tlib#list#Remove([1,2,1,2], 2), [1,1,2])
TAssert IsEqual(tlib#list#RemoveAll([1,2,1,2], 2), [1,1])

TAssert IsEqual(tlib#list#Zip([[1,2,3], [4,5,6]]), [[1,4], [2,5], [3,6]])
TAssert IsEqual(tlib#list#Zip([[1,2,3], [4,5,6,7]]), [[1,4], [2,5], [3,6], ['', 7]])
TAssert IsEqual(tlib#list#Zip([[1,2,3], [4,5,6,7]], -1), [[1,4], [2,5], [3,6], [-1,7]])
TAssert IsEqual(tlib#list#Zip([[1,2,3,7], [4,5,6]], -1), [[1,4], [2,5], [3,6], [7,-1]])


" Vars {{{2
let g:foo = 1
let g:bar = 2
let b:bar = 3
let s:bar = 4

TAssert IsEqual(tlib#var#Get('bar', 'bg'), 3)
TAssert IsEqual(tlib#var#Get('bar', 'g'), 2)
TAssert IsEqual(tlib#var#Get('foo', 'bg'), 1)
TAssert IsEqual(tlib#var#Get('foo', 'g'), 1)
TAssert IsEqual(tlib#var#Get('none', 'l'), '')

TAssert IsEqual(eval(tlib#var#EGet('bar', 'bg')), 3)
TAssert IsEqual(eval(tlib#var#EGet('bar', 'g')), 2)
" TAssert IsEqual(eval(tlib#var#EGet('bar', 'sg')), 4)
TAssert IsEqual(eval(tlib#var#EGet('foo', 'bg')), 1)
TAssert IsEqual(eval(tlib#var#EGet('foo', 'g')), 1)
TAssert IsEqual(eval(tlib#var#EGet('none', 'l')), '')

unlet g:foo
unlet g:bar
unlet b:bar



" Filenames {{{2
TAssert IsEqual(tlib#file#Split('foo/bar/filename.txt'), ['foo', 'bar', 'filename.txt'])
TAssert IsEqual(tlib#file#Split('/foo/bar/filename.txt'), ['', 'foo', 'bar', 'filename.txt'])
TAssert IsEqual(tlib#file#Split('ftp://foo/bar/filename.txt'), ['ftp:/', 'foo', 'bar', 'filename.txt'])

TAssert IsEqual(tlib#file#Join(['foo', 'bar', 'filename.txt']), 'foo/bar/filename.txt')
TAssert IsEqual(tlib#file#Join(['', 'foo', 'bar', 'filename.txt']), '/foo/bar/filename.txt')
TAssert IsEqual(tlib#file#Join(['ftp:/', 'foo', 'bar', 'filename.txt']), 'ftp://foo/bar/filename.txt')

TAssert IsEqual(tlib#file#Relative('foo/bar/filename.txt', 'foo'), 'bar/filename.txt')
TAssert IsEqual(tlib#file#Relative('foo/bar/filename.txt', 'foo/base'), '../bar/filename.txt')
TAssert IsEqual(tlib#file#Relative('filename.txt', 'foo/base'), '../../filename.txt')
TAssert IsEqual(tlib#file#Relative('/foo/bar/filename.txt', '/boo/base'), '../../foo/bar/filename.txt')
TAssert IsEqual(tlib#file#Relative('/bar/filename.txt', '/boo/base'), '../../bar/filename.txt')
TAssert IsEqual(tlib#file#Relative('/foo/bar/filename.txt', '/base'), '../foo/bar/filename.txt')
TAssert IsEqual(tlib#file#Relative('c:/bar/filename.txt', 'x:/boo/base'), 'c:/bar/filename.txt')



" Prototype-based programming {{{2
let test = tlib#Test#New()
TAssert test.IsA('Test')
TAssert !test.IsA('foo')
TAssert test.RespondTo('RespondTo')
TAssert !test.RespondTo('RespondToNothing')
let test1 = tlib#Test#New()
TAssert test.IsRelated(test1)
let testworld = tlib#World#New()
TAssert !test.IsRelated(testworld)

let testc = tlib#TestChild#New()
TAssert IsEqual(testc.Dummy(), 'TestChild.vim')
TAssert IsEqual(testc.Super('Dummy', []), 'Test.vim')



" Optional arguments {{{2
function! TestGetArg(...) "{{{3
    exec tlib#arg#Get(1, 'foo', 1)
    return foo
endf

function! TestGetArg1(...) "{{{3
    exec tlib#arg#Get(1, 'foo', 1, '!= ""')
    return foo
endf

TAssert IsEqual(TestGetArg(), 1)
TAssert IsEqual(TestGetArg(''), '')
TAssert IsEqual(TestGetArg(2), 2)
TAssert IsEqual(TestGetArg1(), 1)
TAssert IsEqual(TestGetArg1(''), 1)
TAssert IsEqual(TestGetArg1(2), 2)

function! TestArgs(...) "{{{3
    exec tlib#arg#Let([['foo', "o"], ['bar', 2]])
    return repeat(foo, bar)
endf
TAssert IsEqual(TestArgs(), 'oo')
TAssert IsEqual(TestArgs('a'), 'aa')
TAssert IsEqual(TestArgs('a', 3), 'aaa')

function! TestArgs1(...) "{{{3
    exec tlib#arg#Let(['foo', ['bar', 2]])
    return repeat(foo, bar)
endf
TAssert IsEqual(TestArgs1(), '')
TAssert IsEqual(TestArgs1('a'), 'aa')
TAssert IsEqual(TestArgs1('a', 3), 'aaa')

function! TestArgs2(...) "{{{3
    exec tlib#arg#Let(['foo', 'bar'], 1)
    return repeat(foo, bar)
endf
TAssert IsEqual(TestArgs2(), '1')
TAssert IsEqual(TestArgs2('a'), 'a')
TAssert IsEqual(TestArgs2('a', 3), 'aaa')

function! TestArgs3(...)
    TVarArg ['a', 1], 'b'
    return a . b
endf
TAssert IsEqual(TestArgs3(), '1')
TAssert IsEqual(TestArgs3('a'), 'a')
TAssert IsEqual(TestArgs3('a', 3), 'a3')

delfunction TestGetArg
delfunction TestGetArg1
delfunction TestArgs
delfunction TestArgs1
delfunction TestArgs2
delfunction TestArgs3



" Strings {{{2
TAssert IsString(tlib#string#RemoveBackslashes('foo bar'))
TAssert IsEqual(tlib#string#RemoveBackslashes('foo bar'), 'foo bar')
TAssert IsEqual(tlib#string#RemoveBackslashes('foo\ bar'), 'foo bar')
TAssert IsEqual(tlib#string#RemoveBackslashes('foo\ \\bar'), 'foo \\bar')
TAssert IsEqual(tlib#string#RemoveBackslashes('foo\ \\bar', '\ '), 'foo \bar')



" Regexp {{{2
for c in split('^$.*+\()|{}[]~', '\zs')
    let s = printf('%sfoo%sbar%s', c, c, c)
    TAssert (s =~ '\m^'. tlib#rx#Escape(s, 'm') .'$')
    TAssert (s =~ '\M^'. tlib#rx#Escape(s, 'M') .'$')
    TAssert (s =~ '\v^'. tlib#rx#Escape(s, 'v') .'$')
    TAssert (s =~ '\V\^'. tlib#rx#Escape(s, 'V') .'\$')
endfor


" Encode, decode
TAssert IsEqual(tlib#url#Decode('http://example.com/foo+bar%25bar'), 'http://example.com/foo bar%bar')
TAssert IsEqual(tlib#url#Decode('Hello%20World.%20%20Good%2c%20bye.'), 'Hello World.  Good, bye.')

TAssert IsEqual(tlib#url#Encode('foo bar%bar'), 'foo+bar%%bar')
TAssert IsEqual(tlib#url#Encode('Hello World. Good, bye.'), 'Hello+World.+Good%2c+bye.')

TAssertEnd test test1 testc testworld


TAssert IsEqual(tlib#string#Count("fooo", "o"), 3)
TAssert IsEqual(tlib#string#Count("***", "\\*"), 3)
TAssert IsEqual(tlib#string#Count("***foo", "\\*"), 3)
TAssert IsEqual(tlib#string#Count("foo***", "\\*"), 3)


finish "{{{1


" Input {{{2
echo tlib#input#List('s', 'Test', ['barfoobar', 'barFoobar'])
echo tlib#input#List('s', 'Test', ['barfoobar', 'bar foo bar', 'barFoobar'])
echo tlib#input#List('s', 'Test', ['barfoobar', 'bar1Foo1bar', 'barFoobar'])
echo tlib#input#EditList('Test', ['bar1', 'bar2', 'bar3', 'foo1', 'foo2', 'foo3'])


autoload/tlib.vim	[[[1
11
" tlib.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-07-17.
" @Last Change: 2013-09-25.
" @Revision:    0.0.12

" :nodefault:
TLet g:tlib#debug = 0

autoload/tlib/notify.vim	[[[1
104
" notify.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-09-19.
" @Last Change: 2012-01-02.
" @Revision:    0.0.19

let s:save_cpo = &cpo
set cpo&vim


" :display: tlib#notify#Echo(text, ?style='')
" Print text in the echo area. Temporarily disable 'ruler' and 'showcmd' 
" in order to prevent |press-enter| messages.
function! tlib#notify#Echo(text, ...)
    TVarArg 'style'
    let ruler = &ruler
    let showcmd = &showcmd
    try
        set noruler
        set noshowcmd
        if !empty(style)
            exec 'echohl '. style
        endif
        echo strpart(a:text, 0, &columns - 1)
    finally
        if !empty(style)
            echohl None
        endif
        let &ruler = ruler
        let &showcmd = showcmd
    endtry
endf


" Contributed by Erik Falor:
" If the line containing the message is too long, echoing it will cause 
" a 'Hit ENTER' prompt to appear.  This function cleans up the line so 
" that does not happen.
" The echoed line is too long if it is wider than the width of the 
" window, minus cmdline space taken up by the ruler and showcmd 
" features.
function! tlib#notify#TrimMessage(message) "{{{3
    let filler = '...'

    " If length of message with tabs converted into spaces + length of 
    " line number + 2 (for the ': ' that follows the line number) is 
    " greater than the width of the screen, truncate in the middle
    let to_fill = &columns
    " TLogVAR to_fill

    " Account for space used by elements in the command-line to avoid 
    " 'Hit ENTER' prompts.
    " If showcmd is on, it will take up 12 columns.
    " If the ruler is enabled, but not displayed in the statusline, it 
    " will in its default form take 17 columns.  If the user defines a 
    " custom &rulerformat, they will need to specify how wide it is.
    if has('cmdline_info')
        if &showcmd
            let to_fill -= 12
        else
            let to_fill -= 1
        endif
        " TLogVAR &showcmd, to_fill

        " TLogVAR &laststatus, &ruler, &rulerformat
        if &ruler
            if &laststatus == 0 || winnr('$') == 1
                if has('statusline')
                    if &rulerformat == ''
                        " default ruler is 17 chars wide
                        let to_fill -= 17
                    elseif exists('g:MP_rulerwidth')
                        let to_fill -= g:MP_rulerwidth
                    else
                        " tml: fallback: guess length
                        let to_fill -= strlen(&rulerformat)
                    endif
                else
                endif
            endif
        else
        endif
    else
        let to_fill -= 1
    endif

    " TLogVAR to_fill
    " TLogDBG strlen(a:message)
    if strlen(a:message) > to_fill
        let front = to_fill / 2 - 1
        let back  = front 
        if to_fill % 2 == 0 | let back -= 1 | endif
        return strpart(a:message, 0, front) . filler .
                    \strpart(a:message, strlen(a:message) - back)
    else
        return a:message
    endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
autoload/tlib/persistent.vim	[[[1
46
" persistent.vim -- Persistent data
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-05-11.
" @Last Change: 2012-05-11.
" @Revision:    9

" The directory for persistent data files. If empty, use 
" |tlib#dir#MyRuntime|.'/share'.
TLet g:tlib_persistent = ''


" :display: tlib#persistent#Dir(?mode = 'bg')
" Return the full directory name for persistent data files.
function! tlib#persistent#Dir() "{{{3
    TVarArg ['mode', 'bg']
    let dir = tlib#var#Get('tlib_persistent', mode)
    if empty(dir)
        let dir = tlib#file#Join([tlib#dir#MyRuntime(), 'share'])
    endif
    return dir
endf

" :def: function! tlib#persistent#Filename(type, ?file=%, ?mkdir=0)
function! tlib#persistent#Filename(type, ...) "{{{3
    " TLogDBG 'bufname='. bufname('.')
    let file = a:0 >= 1 ? a:1 : ''
    let mkdir = a:0 >= 2 ? a:2 : 0
    return tlib#cache#Filename(a:type, file, mkdir, tlib#persistent#Dir())
endf

function! tlib#persistent#Get(...) "{{{3
    return call('tlib#cache#Get', a:000)
endf

function! tlib#persistent#Value(...) "{{{3
    return call('tlib#cache#Value', a:000)
endf

function! tlib#persistent#Save(cfile, dictionary) "{{{3
    if !empty(a:cfile)
        " TLogVAR a:dictionary
        call writefile([string(a:dictionary)], a:cfile, 'b')
    endif
endf

autoload/tlib/vim.vim	[[[1
152
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/tlib_vim/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-07-19.
" @Last Change: 2012-06-08.
" @Revision:    37


let s:restoreframecmd = ''
let s:fullscreen = 0

if has('win16') || has('win32') || has('win64')

    if !exists('g:tlib#vim#simalt_maximize')
        " The alt-key for maximizing the window.
        " CAUTION: The value of this paramter depends on your locale and 
        " maybe the windows version you are running.
        let g:tlib#vim#simalt_maximize = 'x'   "{{{2
    endif

    if !exists('g:tlib#vim#simalt_restore')
        " The alt-key for restoring the window.
        " CAUTION: The value of this paramter depends on your locale and 
        " maybe the windows version you are running.
        let g:tlib#vim#simalt_restore = 'r'   "{{{2
    endif

    if !exists('g:tlib#vim#use_vimtweak')
        " If true, use the vimtweak.dll for windows. This will enable 
        " tlib to remove the caption for fullscreen windows.
        let g:tlib#vim#use_vimtweak = 0   "{{{2
    endif

    " Maximize the window.
    " You might need to redefine |g:tlib#vim#simalt_maximize| if it doesn't 
    " work for you.
    fun! tlib#vim#Maximize(fullscreen) "{{{3
        if !has("gui_running")
            return
        endif
        call s:SaveFrameParams()
        let s:fullscreen = a:fullscreen
        if g:tlib#vim#use_vimtweak && a:fullscreen
            call libcallnr("vimtweak.dll", "EnableCaption", 0)
        endif
        exec 'simalt ~'. g:tlib#vim#simalt_maximize
    endf

    " Restore the original vimsize after having called |tlib#vim#Maximize()|.
    function! tlib#vim#RestoreWindow() "{{{3
        if !has("gui_running")
            return
        endif
        if g:tlib#vim#use_vimtweak
            call libcallnr("vimtweak.dll", "EnableCaption", 1)
        endif
        exec 'simalt ~'. g:tlib#vim#simalt_restore
        call s:RestoreFrameParams()
    endf

else

    if !exists('g:tlib#vim#use_wmctrl')
        " If true, use wmctrl for X windows to make a window 
        " maximized/fullscreen.
        "
        " This is the preferred method for maximizing windows under X 
        " windows. Some window managers have problem coping with the 
        " default method of setting 'lines' and 'columns' to a large 
        " value.
        let g:tlib#vim#use_wmctrl = executable('wmctrl')  "{{{2
    endif

    " :nodoc:
    fun! tlib#vim#Maximize(fullscreen) "{{{3
        if !has("gui_running")
            return
        endif
        call s:SaveFrameParams()
        let s:fullscreen = a:fullscreen
        if g:tlib#vim#use_wmctrl
            if a:fullscreen
                silent !wmctrl -r :ACTIVE: -b add,fullscreen
            else
                silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
            endif
        else
            set lines=1000 columns=1000 
        endif
    endf

    " :nodoc:
    function! tlib#vim#RestoreWindow() "{{{3
        if !has("gui_running")
            return
        endif
        if g:tlib#vim#use_wmctrl
            if s:fullscreen
                silent !wmctrl -r :ACTIVE: -b remove,fullscreen
            else
                silent !wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
            endif
        endif
        call s:RestoreFrameParams()
    endf

endif


function! s:SaveFrameParams() "{{{3
    let s:restoreframecmd = printf("set lines=%d columns=%d | winpos %d %d", &lines, &columns, getwinposx(), getwinposy())
endf


function! s:RestoreFrameParams() "{{{3
    if !empty(s:restoreframecmd)
        exec s:restoreframecmd
        let s:restoreframecmd = ''
    endif
endf


" :display: tlib#vim##CopyFunction(old, new, overwrite=0)
function! tlib#vim#CopyFunction(old, new, ...) "{{{3
    let overwrite = a:0 >= 1 ? a:1 : 0
    redir => oldfn
    exec 'silent function' a:old
    redir END
    if exists('*'. a:new)
        if overwrite > 0
            exec 'delfunction' a:new
        elseif overwrite < 0
            throw 'tlib#vim##CopyFunction: Function already exists: '. a:old .' -> '. a:new
        else
            return
        endif
    endif
    let fn = split(oldfn, '\n')
    let fn = map(fn, 'substitute(v:val, ''^\d\+'', "", "")')
    let fn[0] = substitute(fn[0], '\V\^\s\*fu\%[nction]!\?\s\+\zs'. a:old, a:new, '')
    let t = @t
    try
        let @t = join(fn, "\n")
        redir => out
        @t
        redir END
    finally
        let @t = t
    endtry
endf

autoload/tlib/progressbar.vim	[[[1
80
" progressbar.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-30.
" @Last Change: 2010-01-07.
" @Revision:    0.0.69

if &cp || exists("loaded_tlib_progressbar_autoload")
    finish
endif
let loaded_tlib_progressbar_autoload = 1

let s:statusline = []
let s:laststatus = []
let s:max = []
let s:format = []
let s:width = []
let s:value = []
let s:timestamp = -1

" EXAMPLE: >
"     call tlib#progressbar#Init(20)
"     try
"         for i in range(20)
"             call tlib#progressbar#Display(i)
"             call DoSomethingThatTakesSomeTime(i)
"         endfor
"     finally
"         call tlib#progressbar#Restore()
"     endtry
function! tlib#progressbar#Init(max, ...) "{{{3
    TVarArg ['format', '%s'], ['width', 10]
    call insert(s:statusline, &statusline)
    call insert(s:laststatus, &laststatus)
    call insert(s:max, a:max)
    call insert(s:format, format)
    call insert(s:width, width)
    call insert(s:value, -1)
    let &laststatus = 2
    let s:timestamp = localtime()
endf


function! tlib#progressbar#Display(value, ...) "{{{3
    TVarArg 'extra'
    let ts = localtime()
    if ts == s:timestamp
        return
    else
        let s:timestamp = ts
    endif
    let val = a:value * s:width[0] / s:max[0]
    if val != s:value[0]
        let s:value[0] = val
        let pbl = repeat('#', val)
        let pbr = repeat('.', s:width[0] - val)
        let txt = printf(s:format[0], '['.pbl.pbr.']') . extra
        let &l:statusline = txt
        " TLogDBG txt
        redrawstatus
        " redraw
        " call tlib#notify#Echo(txt)
    endif
endf


function! tlib#progressbar#Restore() "{{{3
    let &l:statusline = remove(s:statusline, 0)
    let &laststatus = remove(s:laststatus, 0)
    redrawstatus
    " redraw
    " echo
    call remove(s:max, 0)
    call remove(s:format, 0)
    call remove(s:width, 0)
    call remove(s:value, 0)
endf


autoload/tlib/TestChild.vim	[[[1
27
" TestChild.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-05-18.
" @Last Change: 2010-09-05.
" @Revision:    0.1.14

" :enddoc:

if &cp || exists("loaded_tlib_TestChild_autoload")
    finish
endif
let loaded_tlib_TestChild_autoload = 1


let s:prototype = tlib#Test#New({'_class': ['TestChild']}) "{{{2
function! tlib#TestChild#New(...) "{{{3
    let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
    return object
endf


function! s:prototype.Dummy() dict "{{{3
    return 'TestChild.vim'
endf

autoload/tlib/eval.vim	[[[1
55
" eval.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-16.
" @Last Change: 2009-02-15.
" @Revision:    0.0.34

if &cp || exists("loaded_tlib_eval_autoload")
    finish
endif
let loaded_tlib_eval_autoload = 1


function! tlib#eval#FormatValue(value, ...) "{{{3
    TVarArg ['indent', 0]
    " TLogVAR a:value, indent
    let indent1 = indent + 1
    let indenti = repeat(' ', &sw)
    let type = type(a:value)
    let acc = []
    if type == 0 || type == 1 || type == 2
        " TLogDBG 'Use string() for type='. type
        call add(acc, string(a:value))
    elseif type == 3 "List
        " TLogDBG 'List'
        call add(acc, '[')
        for e in a:value
            call add(acc, printf('%s%s,', indenti, tlib#eval#FormatValue(e, indent1)))
            unlet e
        endfor
        call add(acc, ']')
    elseif type == 4 "Dictionary
        " TLogDBG 'Dictionary'
        call add(acc, '{')
        let indent1 = indent + 1
        for [k, v] in items(a:value)
            call add(acc, printf("%s%s: %s,", indenti, string(k), tlib#eval#FormatValue(v, indent1)))
            unlet k v
        endfor
        call add(acc, '}')
    else
        " TLogDBG 'Unknown type: '. string(a:value)
        call add(acc, string(a:value))
    endif
    if indent > 0
        let is = repeat(' ', indent * &sw)
        for i in range(1,len(acc) - 1)
            let acc[i] = is . acc[i]
        endfor
    endif
    return join(acc, "\n")
endf


autoload/tlib/list.vim	[[[1
164
" list.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2011-03-18.
" @Revision:    36


""" List related functions {{{1
" For the following functions please see ../../test/tlib.vim for examples.

" :def: function! tlib#list#Inject(list, initial_value, funcref)
" EXAMPLES: >
"   echo tlib#list#Inject([1,2,3], 0, function('Add')
"   => 6
function! tlib#list#Inject(list, value, Function) "{{{3
    if empty(a:list)
        return a:value
    else
        let item  = a:list[0]
        let rest  = a:list[1:-1]
        let value = call(a:Function, [a:value, item])
        return tlib#list#Inject(rest, value, a:Function)
    endif
endf


" EXAMPLES: >
"   tlib#list#Compact([0,1,2,3,[], {}, ""])
"   => [1,2,3]
function! tlib#list#Compact(list) "{{{3
    return filter(copy(a:list), '!empty(v:val)')
endf


" EXAMPLES: >
"   tlib#list#Flatten([0,[1,2,[3,""]]])
"   => [0,1,2,3,""]
function! tlib#list#Flatten(list) "{{{3
    let acc = []
    for e in a:list
        if type(e) == 3
            let acc += tlib#list#Flatten(e)
        else
            call add(acc, e)
        endif
        unlet e
    endfor
    return acc
endf


" :def: function! tlib#list#FindAll(list, filter, ?process_expr="")
" Basically the same as filter()
"
" EXAMPLES: >
"   tlib#list#FindAll([1,2,3], 'v:val >= 2')
"   => [2, 3]
function! tlib#list#FindAll(list, filter, ...) "{{{3
    let rv   = filter(copy(a:list), a:filter)
    if a:0 >= 1 && a:1 != ''
        let rv = map(rv, a:1)
    endif
    return rv
endf


" :def: function! tlib#list#Find(list, filter, ?default="", ?process_expr="")
"
" EXAMPLES: >
"   tlib#list#Find([1,2,3], 'v:val >= 2')
"   => 2
function! tlib#list#Find(list, filter, ...) "{{{3
    let default = a:0 >= 1 ? a:1 : ''
    let expr    = a:0 >= 2 ? a:2 : ''
    return get(tlib#list#FindAll(a:list, a:filter, expr), 0, default)
endf


" EXAMPLES: >
"   tlib#list#Any([1,2,3], 'v:val >= 2')
"   => 1
function! tlib#list#Any(list, expr) "{{{3
    return !empty(tlib#list#FindAll(a:list, a:expr))
endf


" EXAMPLES: >
"   tlib#list#All([1,2,3], 'v:val >= 2')
"   => 0
function! tlib#list#All(list, expr) "{{{3
    return len(tlib#list#FindAll(a:list, a:expr)) == len(a:list)
endf


" EXAMPLES: >
"   tlib#list#Remove([1,2,1,2], 2)
"   => [1,1,2]
function! tlib#list#Remove(list, element) "{{{3
    let idx = index(a:list, a:element)
    if idx != -1
        call remove(a:list, idx)
    endif
    return a:list
endf


" EXAMPLES: >
"   tlib#list#RemoveAll([1,2,1,2], 2)
"   => [1,1]
function! tlib#list#RemoveAll(list, element) "{{{3
    call filter(a:list, 'v:val != a:element')
    return a:list
endf


" :def: function! tlib#list#Zip(lists, ?default='')
" EXAMPLES: >
"   tlib#list#Zip([[1,2,3], [4,5,6]])
"   => [[1,4], [2,5], [3,6]]
function! tlib#list#Zip(lists, ...) "{{{3
    TVarArg 'default'
    let lists = copy(a:lists)
    let max   = 0
    for l in lists
        let ll = len(l)
        if ll > max
            let max = ll
        endif
    endfor
    " TLogVAR default, max
    return map(range(0, max - 1), 's:GetNthElement(v:val, lists, default)')
endf

function! s:GetNthElement(n, lists, default) "{{{3
    " TLogVAR a:n, a:lists, a:default
    return map(copy(a:lists), 'get(v:val, a:n, a:default)')
endf


function! tlib#list#Uniq(list, ...) "{{{3
    TVarArg ['get_value', '']
    let s:uniq_values = {}
    if empty(get_value)
        call filter(a:list, 's:UniqValue(v:val)')
    else
        call filter(a:list, 's:UniqValue(eval(printf(get_value, string(v:val))))')
    endif
    unlet s:uniq_values
    return a:list
endf


function! s:UniqValue(value) "{{{3
    if get(s:uniq_values, a:value, 0)
        return 0
    else
        let s:uniq_values[a:value] = 1
        return 1
    endif
endf


autoload/tlib/cmd.vim	[[[1
111
" cmd.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-08-23.
" @Last Change: 2014-02-05.
" @Revision:    0.0.53

if &cp || exists("loaded_tlib_cmd_autoload")
    finish
endif
let loaded_tlib_cmd_autoload = 1


let g:tlib#cmd#last_output = []


function! tlib#cmd#OutputAsList(command) "{{{3
    " TLogVAR a:command
    if exists('s:redir_lines')
        redir END
        let cache = s:redir_lines
    endif
    let s:redir_lines = ''
    redir =>> s:redir_lines
    silent! exec a:command
    redir END
    let g:tlib#cmd#last_output = split(s:redir_lines, '\n')
    unlet s:redir_lines
    if exists('cache')
        let s:redir_lines = cache
        redir =>> s:redir_lines
    endif
    return g:tlib#cmd#last_output
endf


" See |:TBrowseOutput|.
function! tlib#cmd#BrowseOutput(command) "{{{3
    call tlib#cmd#BrowseOutputWithCallback("tlib#cmd#DefaultBrowseOutput", a:command)
endf

" :def: function! tlib#cmd#BrowseOutputWithCallback(callback, command)
" Execute COMMAND and present its output in a |tlib#input#List()|;
" when a line is selected, execute the function named as the CALLBACK
" and pass in that line as an argument.
"
" The CALLBACK function gives you an opportunity to massage the COMMAND output
" and possibly act on it in a meaningful way. For example, if COMMAND listed
" all URIs found in the current buffer, CALLBACK could validate and then open
" the selected URI in the system's default browser.
"
" This function is meant to be a tool to help compose the implementations of
" powerful commands that use |tlib#input#List()| as a common interface. See
" |TBrowseScriptnames| as an example.
"
" EXAMPLES: >
"   call tlib#cmd#BrowseOutputWithCallback('tlib#cmd#ParseScriptname', 'scriptnames')
function! tlib#cmd#BrowseOutputWithCallback(callback, command) "{{{3
    let list = tlib#cmd#OutputAsList(a:command)
    let cmds = tlib#input#List('m', 'Output of: '. a:command, list)
    if !empty(cmds)
        for cmd in cmds
            let Callback = function(a:callback)
            call call(Callback, [cmd])
        endfor
    endif
endf

function! tlib#cmd#DefaultBrowseOutput(cmd) "{{{3
    call feedkeys(':'. a:cmd)
endf

function! tlib#cmd#ParseScriptname(line) "{{{3
    " let parsedValue = substitute(a:line, '^.\{-}\/', '/', '')
    let parsedValue = matchstr(a:line, '^\s*\d\+:\s*\zs.*$')
    exe 'drop '. fnameescape(parsedValue)
endf

" :def: function! tlib#cmd#UseVertical(?rx='')
" Look at the history whether the command was called with vertical. If 
" an rx is provided check first if the last entry in the history matches 
" this rx.
function! tlib#cmd#UseVertical(...) "{{{3
    TVarArg ['rx']
    let h0 = histget(':')
    let rx0 = '\C\<vert\%[ical]\>\s\+'
    if !empty(rx)
        let rx0 .= '.\{-}'.rx
    endif
    " TLogVAR h0, rx0
    return h0 =~ rx0
endf


" Print the time in seconds or milliseconds (if your version of VIM 
" has |+reltime|) a command takes.
function! tlib#cmd#Time(cmd) "{{{3
    if has('reltime')
        let start = tlib#time#Now()
        exec a:cmd
        let end = tlib#time#Now()
        let diff = string(tlib#time#Diff(end, start)) .'ms'
    else
        let start = localtime()
        exec a:cmd
        let diff = (localtime() - start) .'s'
    endif
    echom 'Time: '. diff .': '. a:cmd
endf

autoload/tlib/syntax.vim	[[[1
51
" syntax.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-11-19.
" @Last Change: 2009-02-15.
" @Revision:    0.0.11

if &cp || exists("loaded_tlib_syntax_autoload")
    finish
endif
let loaded_tlib_syntax_autoload = 1
let s:save_cpo = &cpo
set cpo&vim


function! tlib#syntax#Collect() "{{{3
    let acc = {}
    let syn = ''
    for line in tlib#cmd#OutputAsList('syntax')
        if line =~ '^---'
            continue
        elseif line =~ '^\w'
            let ml = matchlist(line, '^\(\w\+\)\s\+\(xxx\s\+\(.*\)\|\(cluster.*\)\)$')
            if empty(ml)
                echoerr 'Internal error: '. string(line)
            else
                let [m_0, syn, m_1, m_def1, m_def2; m_rest] = ml
                let acc[syn] = [empty(m_def1) ? m_def2 : m_def1]
            endif
        else
            call add(acc[syn], matchstr(line, '^\s\+\zs.*$'))
        endif
    endfor
    return acc
endf


" :def: function! tlib#syntax#Names(?rx='')
function! tlib#syntax#Names(...) "{{{3
    TVarArg 'rx'
    let names = keys(tlib#syntax#Collect())
    if !empty(rx)
        call filter(names, 'v:val =~ rx')
    endif
    return names
endf


let &cpo = s:save_cpo
unlet s:save_cpo
autoload/tlib/balloon.vim	[[[1
54
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/tlib_vim/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-08-30.
" @Last Change: 2010-09-05.
" @Revision:    27


function! tlib#balloon#Register(expr) "{{{3
    if !has('balloon_eval')
        return
    endif
    if !exists('b:tlib_balloons')
        let b:tlib_balloons = []
    endif
    if !&ballooneval
        setlocal ballooneval
    endif
    if &balloonexpr != 'tlib#balloon#Expr()'
        if !empty(&balloonexpr)
            call add(b:tlib_balloons, &balloonexpr)
        endif
        setlocal ballooneval balloonexpr=tlib#balloon#Expr()
    endif
    if index(b:tlib_balloons, a:expr) == -1
        call add(b:tlib_balloons, a:expr)
    endif
endf


function! tlib#balloon#Remove(expr) "{{{3
    if !exists('b:tlib_balloons')
        call filter(b:tlib_balloons, 'v:val != a:expr')
    endif
endf


function! tlib#balloon#Expr() "{{{3
    " TLogVAR exists('b:tlib_balloons')
    if !exists('b:tlib_balloons')
        return ''
    endif
    let text = map(copy(b:tlib_balloons), 'eval(v:val)')
    " TLogVAR b:tlib_balloons, text
    call filter(text, '!empty(v:val)')
    if has('balloon_multiline')
        return join(text, "\n----------------------------------\n")
    else
        return get(text, 0, '')
    endif
endf


autoload/tlib/vcs.vim	[[[1
155
" vcs.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-03-08.
" @Last Change: 2012-09-10.
" @Revision:    122


" A dictionarie of supported VCS (currently: git, hg, svn, bzr).
" :display: g:tlib#vcs#def                 {...}
TLet g:tlib#vcs#def = {
            \ 'git': {
            \     'dir': '.git',
            \     'ls': 'git ls-files --full-name %s',
            \     'diff': 'git diff --no-ext-diff -U0 %s'
            \ },
            \ 'hg': {
            \     'dir': '.hg',
            \     'diff': 'hg diff -U0 %s',
            \     'ls': 'hg manifest'
            \ },
            \ 'svn': {
            \     'dir': '.svn',
            \     'diff': 'svn diff --diff-cmd diff --extensions -U0 %s',
            \ },
            \ 'bzr': {
            \     'dir': '.bzr',
            \     'diff': 'bzr diff --diff-options=-U0 %s',
            \ }
            \ }


" A dictionary of custom executables for VCS commands. If the value is 
" empty, support for that VCS will be removed. If no key is present, it 
" is assumed that the VCS "type" is the name of the executable.
" :display: g:tlib#vcs#executables         {...}
TLet g:tlib#vcs#executables = {} 


" If non-empty, use it as a format string to check whether a VCS is 
" installed on your computer.
TLet g:tlib#vcs#check = has('win16') || has('win32') || has('win64') ? '%s.exe' : '%s'


if !empty(g:tlib#vcs#check)
    for [s:cmd, s:def] in items(g:tlib#vcs#def)
        if !has_key(g:tlib#vcs#executables, s:cmd)
            let s:cmd1 = printf(g:tlib#vcs#check, s:cmd)
            let g:tlib#vcs#executables[s:cmd] = executable(s:cmd1) ? s:cmd1 : ''
        endif
    endfor
endif


function! tlib#vcs#FindVCS(filename) "{{{3
    let type = ''
    let dir  = ''
    " let path = escape(fnamemodify(a:filename, ':p'), ',:') .';'
    let filename = fnamemodify(a:filename, isdirectory(a:filename) ? ':p:h' : ':p')
    let path = escape(filename, ';') .';'
    " TLogVAR a:filename, path
    let depth = -1
    for vcs in keys(g:tlib#vcs#def)
        let subdir = g:tlib#vcs#def[vcs].dir
        let vcsdir = finddir(subdir, path)
        " TLogVAR vcs, subdir, vcsdir
        if !empty(vcsdir)
            let vcsdir_depth = len(split(fnamemodify(vcsdir, ':p'), '\/'))
            if vcsdir_depth > depth
                let depth = vcsdir_depth
                let type = vcs
                let dir = vcsdir
                " TLogVAR type, depth
            endif
        endif
    endfor
    " TLogVAR type, dir
    if empty(type)
        return ['', '']
    else
        return [type, dir]
    endif
endf


function! s:GetCmd(vcstype, cmd)
    let vcsdef = get(g:tlib#vcs#def, a:vcstype, {})
    if has_key(vcsdef, a:cmd)
        let cmd = vcsdef[a:cmd]
        let bin = get(g:tlib#vcs#executables, a:vcstype, '')
        if empty(bin)
            let cmd = ''
        elseif bin != a:vcstype
            " let bin = escape(shellescape(bin), '\')
            let bin = escape(bin, '\')
            let cmd = substitute(cmd, '^.\{-}\zs'. escape(a:vcstype, '\'), bin, '')
        endif
        return cmd
    else
        return ''
    endif
endf


" :display: tlib#vcs#Ls(?filename=bufname('%'), ?vcs=[type, dir])
" Return the files under VCS.
function! tlib#vcs#Ls(...) "{{{3
    if a:0 >= 2
        let vcs = a:2
    else
        let vcs = tlib#vcs#FindVCS(a:0 >= 1 ? a:1 : bufname('%'))
    endif
    " TLogVAR vcs
    if !empty(vcs)
        let [vcstype, vcsdir] = vcs
        if has_key(g:tlib#vcs#def, vcstype)
            let ls = s:GetCmd(vcstype, 'ls')
            " TLogVAR ls
            if !empty(ls)
                let rootdir = fnamemodify(vcsdir, ':p:h:h')
                " TLogVAR vcsdir, rootdir
                if ls =~ '%s'
                    let cmd = printf(ls, shellescape(rootdir))
                else
                    let cmd = ls
                endif
                " TLogVAR cmd
                let filess = system(cmd)
                " TLogVAR filess
                let files = split(filess, '\n')
                call map(files, 'join([rootdir, v:val], "/")')
                return files
            endif
        endif
    endif
    return []
endf


" :display: tlib#vcs#Diff(filename, ?vcs=[type, dir])
" Return the diff for "filename"
function! tlib#vcs#Diff(filename, ...) "{{{3
    let vcs = a:0 >= 1 ? a:1 : tlib#vcs#FindVCS(a:filename)
    if !empty(vcs)
        let [vcstype, vcsdir] = vcs
        let diff = s:GetCmd(vcstype, 'diff')
        if !empty(diff)
            let cmd = printf(diff, shellescape(fnamemodify(a:filename, ':p')))
            let patch = system(cmd)
            return patch
        endif
    endif
    return []
endf

autoload/tlib/char.vim	[[[1
67
" char.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2014-01-20.
" @Revision:    0.0.37

if &cp || exists("loaded_tlib_char_autoload")
    finish
endif
let loaded_tlib_char_autoload = 1


" :def: function! tlib#char#Get(?timeout=0)
" Get a character.
"
" EXAMPLES: >
"   echo tlib#char#Get()
"   echo tlib#char#Get(5)
function! tlib#char#Get(...) "{{{3
    TVarArg ['timeout', 0], ['resolution', 0], ['getmod', 0]
    let char = -1
    let mode = 0
    if timeout == 0 || !has('reltime')
        let char = getchar()
    else
        let char = tlib#char#GetWithTimeout(timeout, resolution)
    endif
    if getmod
        if char != -1
            let mode = getcharmod()
        endif
        return [char, mode]
    else
        return char
    endif
endf


function! tlib#char#IsAvailable() "{{{3
    let ch = getchar(1)
    return type(ch) == 0 && ch != 0
endf


function! tlib#char#GetWithTimeout(timeout, ...) "{{{3
    TVarArg ['resolution', 2]
    " TLogVAR a:timeout, resolution
    let start = tlib#time#MSecs()
    while 1
        let c = getchar(0)
        if type(c) != 0 || c != 0
            return c
        else
            let now = tlib#time#MSecs()
            let diff = tlib#time#DiffMSecs(now, start, resolution)
            " TLogVAR diff
            if diff > a:timeout
                return -1
            endif
        endif
    endwh
    return -1
endf


autoload/tlib/Filter_glob.vim	[[[1
68
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-11-25.
" @Last Change: 2014-01-23.
" @Revision:    0.0.80

let s:prototype = tlib#Filter_cnf#New({'_class': ['Filter_glob'], 'name': 'glob'}) "{{{2
let s:prototype.highlight = g:tlib#input#higroup


" A character that should be expanded to '\.\{-}'.
TLet g:tlib#Filter_glob#seq = '*'


" A character that should be expanded to '\.\?'.
TLet g:tlib#Filter_glob#char = '?'


" The same as |tlib#Filter_cnf#New()| but a a customizable character 
" |see tlib#Filter_glob#seq| is expanded to '\.\{-}' and 
" |g:tlib#Filter_glob#char| is expanded to '\.'.
" The pattern is a '/\V' very no-'/magic' regexp pattern.
function! tlib#Filter_glob#New(...) "{{{3
    let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
    return object
endf


let s:Help = s:prototype.Help

" :nodoc:
function! s:prototype.Help(world) dict "{{{3
    call call(s:Help, [a:world], self)
    call a:world.PushHelp(g:tlib#Filter_glob#seq, 'Any characters')
    call a:world.PushHelp(g:tlib#Filter_glob#char, 'Single characters')
endf


" :nodoc:
function! s:prototype.SetFrontFilter(world, pattern) dict "{{{3
    let pattern = substitute(a:pattern, tlib#rx#Escape(g:tlib#Filter_glob#seq, 'V'), '\\.\\{-}', 'g')
    let pattern = substitute(a:pattern, tlib#rx#Escape(g:tlib#Filter_glob#char, 'V'), '\\.', 'g')
    let a:world.filter[0] = reverse(split(pattern, '\s*|\s*')) + a:world.filter[0][1 : -1]
endf


" :nodoc:
function! s:prototype.PushFrontFilter(world, char) dict "{{{3
    " TLogVAR a:char, nr2char(a:char)
    if a:char == char2nr(g:tlib#Filter_glob#seq)
        let char = '\.\{-}'
    elseif a:char == char2nr(g:tlib#Filter_glob#char)
        let char = '\.'
    else
        let char = nr2char(a:char)
    endif
    let a:world.filter[0][0] .= char
endf


" :nodoc:
function! s:prototype.CleanFilter(filter) dict "{{{3
    let filter = substitute(a:filter, '\\.\\{-}', g:tlib#Filter_glob#seq, 'g')
    let filter = substitute(filter, '\\.', g:tlib#Filter_glob#char, 'g')
    return filter
endf

autoload/tlib/scratch.vim	[[[1
143
" scratch.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-07-18.
" @Last Change: 2014-02-06.
" @Revision:    0.0.252

if &cp || exists("loaded_tlib_scratch_autoload")
    finish
endif
let loaded_tlib_scratch_autoload = 1


" Scratch window position. By default the list window is opened on the 
" bottom. Set this variable to 'topleft' or '' to change this behaviour.
" See |tlib#input#List()|.
TLet g:tlib_scratch_pos = 'botright'

" If you want the scratch buffer to be fully removed, you might want to 
" set this variable to 'wipe'.
" See also https://github.com/tomtom/tlib_vim/pull/16
TLet g:tlib#scratch#hidden = 'hide'


" :def: function! tlib#scratch#UseScratch(?keyargs={})
" Display a scratch buffer (a buffer with no file). See :TScratch for an 
" example.
" Return the scratch buffer's number.
" Values for keyargs:
"   scratch_split ... 1: split, 0: window, -1: tab
function! tlib#scratch#UseScratch(...) "{{{3
    exec tlib#arg#Let([['keyargs', {}]])
    " TLogDBG string(keys(keyargs))
    let id = get(keyargs, 'scratch', '__Scratch__')
    " TLogVAR id, bufwinnr(id)
    " TLogVAR bufnr(id), bufname(id)
    " TLogVAR 1, winnr(), bufnr('%'), bufname("%")
    if bufwinnr(id) != -1
        " echom 'DBG noautocmd keepalt keepj' bufwinnr(id) 'wincmd w'
        exec 'noautocmd keepalt keepj' bufwinnr(id) 'wincmd w'
        " TLogVAR "reuse", bufnr("%"), bufname("%")
    else
        let winpos = ''
        let bn = bufnr(id)
        let wpos = get(keyargs, 'scratch_pos', g:tlib_scratch_pos)
        " TLogVAR keyargs.scratch_vertical
        if get(keyargs, 'scratch_vertical')
            let wpos .= ' vertical'
            let winpos = tlib#fixes#Winpos()
        endif
        " TLogVAR wpos
        let scratch_split = get(keyargs, 'scratch_split', 1)
        if bn != -1
            " TLogVAR bn
            let wn = bufwinnr(bn)
            if wn != -1
                " TLogVAR wn
                exec 'noautocmd keepalt keepj' (wn .'wincmd w')
            else
                if scratch_split == 1
                    let cmd = wpos.' sbuffer!'
                elseif scratch_split == -1
                    let cmd = wpos.' tab sbuffer!'
                else
                    let cmd = 'buffer!'
                endif
                " TLogVAR cmd, bn
                silent exec 'noautocmd keepalt keepj' cmd bn
            endif
        else
            " TLogVAR id
            if scratch_split == 1
                let cmd = wpos.' split'
            elseif scratch_split == -1
                let cmd = wpos.' tab split'
            else
                let cmd = 'edit'
            endif
            " TLogVAR cmd, id
            silent exec 'noautocmd keepalt keepj' cmd escape(id, '%#\ ')
            " silent exec 'split '. id
        endif
        let ft = get(keyargs, 'scratch_filetype', '')
        " TLogVAR ft, winpos
        if !empty(winpos)
            exec winpos
        endif
        setlocal buftype=nofile
        let &l:bufhidden = get(keyargs, 'scratch_hidden', g:tlib#scratch#hidden)
        setlocal noswapfile
        setlocal nobuflisted
        setlocal foldmethod=manual
        setlocal foldcolumn=0
        setlocal modifiable
        setlocal nospell
        " TLogVAR &ft, ft
        if !empty(ft)
            let &l:ft = ft
        endif
    endif
    let keyargs.scratch = bufnr('%')
    let keyargs.scratch_tabpagenr = tabpagenr()
    let keyargs.scratch_winnr = winnr()
    " TLogVAR 2, winnr(), bufnr('%'), bufname("%"), keyargs.scratch
    return keyargs.scratch
endf


" Close a scratch buffer as defined in keyargs (usually a World).
" Return 1 if the scratch buffer is closed (or if it already was 
" closed).
function! tlib#scratch#CloseScratch(keyargs, ...) "{{{3
    TVarArg ['reset_scratch', 1]
    let scratch = get(a:keyargs, 'scratch', '')
    " TLogVAR scratch, reset_scratch
    " TLogDBG string(tlib#win#List())
    if !empty(scratch) && winnr('$') > 1
        let wn = bufwinnr(scratch)
        " TLogVAR wn
        try
            if wn != -1
                " TLogDBG winnr()
                let wb = tlib#win#Set(wn)
                let winpos = tlib#fixes#Winpos()
                wincmd c
                if get(a:keyargs, 'scratch_vertical') && !empty(winpos)
                    exec winpos
                endif
                " exec wb 
                " redraw
                " TLogVAR winnr()
            endif
            return 1
        finally
            if reset_scratch
                let a:keyargs.scratch = ''
            endif
        endtry
    endif
    return 0
endf

autoload/tlib/autocmdgroup.vim	[[[1
14
" autocmdgroup.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    7

augroup TLib
    autocmd!
augroup END


function! tlib#autocmdgroup#Init() "{{{3
endf

autoload/tlib/cache.vim	[[[1
312
" cache.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2013-09-25.
" @Revision:    0.1.230


" The cache directory. If empty, use |tlib#dir#MyRuntime|.'/cache'.
" You might want to delete old files from this directory from time to 
" time with a command like: >
"   find ~/vimfiles/cache/ -atime +31 -type f -print -delete
TLet g:tlib_cache = ''

" |tlib#cache#Purge()|: Remove cache files older than N days.
TLet g:tlib#cache#purge_days = 31

" Purge the cache every N days. Disable automatic purging by setting 
" this value to a negative value.
TLet g:tlib#cache#purge_every_days = 31

" The encoding used for the purge-cache script.
" Default: 'enc'
TLet g:tlib#cache#script_encoding = &enc

" Whether to run the directory removal script:
"    0 ... No
"    1 ... Query user
"    2 ... Yes
TLet g:tlib#cache#run_script = 1

" Verbosity level:
"     0 ... Be quiet
"     1 ... Display informative message
"     2 ... Display detailed messages
TLet g:tlib#cache#verbosity = 1

" A list of regexps that are matched against partial filenames of the 
" cached files. If a regexp matches, the file won't be removed by 
" |tlib#cache#Purge()|.
TLet g:tlib#cache#dont_purge = ['[\/]\.last_purge$']

" If the cache filename is longer than N characters, use 
" |pathshorten()|.
TLet g:tlib#cache#max_filename = 200


" :display: tlib#cache#Dir(?mode = 'bg')
" The default cache directory.
function! tlib#cache#Dir(...) "{{{3
    TVarArg ['mode', 'bg']
    let dir = tlib#var#Get('tlib_cache', mode)
    if empty(dir)
        let dir = tlib#file#Join([tlib#dir#MyRuntime(), 'cache'])
    endif
    return dir
endf


" :def: function! tlib#cache#Filename(type, ?file=%, ?mkdir=0, ?dir='')
function! tlib#cache#Filename(type, ...) "{{{3
    " TLogDBG 'bufname='. bufname('.')
    let dir0 = a:0 >= 3 && !empty(a:3) ? a:3 : tlib#cache#Dir()
    let dir = dir0
    if a:0 >= 1 && !empty(a:1)
        let file  = a:1
    else
        if empty(expand('%:t'))
            return ''
        endif
        let file  = expand('%:p')
        let file  = tlib#file#Relative(file, tlib#file#Join([dir, '..']))
    endif
    " TLogVAR file, dir
    let mkdir = a:0 >= 2 ? a:2 : 0
    let file  = substitute(file, '\.\.\|[:&<>]\|//\+\|\\\\\+', '_', 'g')
    let dirs  = [dir, a:type]
    let dirf  = fnamemodify(file, ':h')
    if dirf != '.'
        call add(dirs, dirf)
    endif
    let dir   = tlib#file#Join(dirs)
    " TLogVAR dir
    let dir   = tlib#dir#PlainName(dir)
    " TLogVAR dir
    let file  = fnamemodify(file, ':t')
    " TLogVAR file, dir, mkdir
    let cache_file = tlib#file#Join([dir, file])
    if len(cache_file) > g:tlib#cache#max_filename
        let shortfilename = pathshorten(file) .'_'. tlib#hash#Adler32(file)
        let cache_file = tlib#cache#Filename(a:type, shortfilename, mkdir, dir0)
    else
        if mkdir && !isdirectory(dir)
            try
                call mkdir(dir, 'p')
            catch /^Vim\%((\a\+)\)\=:E739:/
                if filereadable(dir) && !isdirectory(dir)
                    echoerr 'TLib: Cannot create directory for cache file because a file with the same name exists (please delete it):' dir
                    " call delete(dir)
                    " call mkdir(dir, 'p')
                endif
            endtry
        endif
    endif
    " TLogVAR cache_file
    return cache_file
endf


function! tlib#cache#Save(cfile, dictionary) "{{{3
    " TLogVAR a:cfile, a:dictionary
    call tlib#persistent#Save(a:cfile, a:dictionary)
endf


function! tlib#cache#Get(cfile, ...) "{{{3
    call tlib#cache#MaybePurge()
    if !empty(a:cfile) && filereadable(a:cfile)
        let val = readfile(a:cfile, 'b')
        return eval(join(val, "\n"))
    else
        let default = a:0 >= 1 ? a:1 : {}
        return default
    endif
endf


" Get a cached value from cfile. If it is outdated (compared to ftime) 
" or does not exist, create it calling a generator function.
function! tlib#cache#Value(cfile, generator, ftime, ...) "{{{3
    if !filereadable(a:cfile) || (a:ftime != 0 && getftime(a:cfile) < a:ftime)
        if empty(a:generator) && a:0 >= 1
            " TLogVAR a:1
            let val = a:1
        else
            let args = a:0 >= 1 ? a:1 : []
            " TLogVAR a:generator, args
            let val = call(a:generator, args)
        endif
        " TLogVAR val
        let cval = {'val': val}
        " TLogVAR cval
        call tlib#cache#Save(a:cfile, cval)
        return val
    else
        let val = tlib#cache#Get(a:cfile)
        return val.val
    endif
endf


" Call |tlib#cache#Purge()| if the last purge was done before 
" |g:tlib#cache#purge_every_days|.
function! tlib#cache#MaybePurge() "{{{3
    if g:tlib#cache#purge_every_days < 0
        return
    endif
    let dir = tlib#cache#Dir('g')
    let last_purge = tlib#file#Join([dir, '.last_purge'])
    let last_purge_exists = filereadable(last_purge)
    if last_purge_exists
        let threshold = localtime() - g:tlib#cache#purge_every_days * g:tlib#date#dayshift
        let should_purge = getftime(last_purge) < threshold
    else
        let should_purge = 0 " should ignore empty dirs, like the tmru one: !empty(glob(tlib#file#Join([dir, '**'])))
    endif
    if should_purge
        if last_purge_exists
            let yn = 'y'
        else
            let txt = "TLib: The cache directory '". dir ."' should be purged of old files.\nDelete files older than ". g:tlib#cache#purge_days ." days now?"
            let yn = tlib#input#Dialog(txt, ['yes', 'no'], 'no')
        endif
        if yn =~ '^y\%[es]$'
            call tlib#cache#Purge()
        else
            let g:tlib#cache#purge_every_days = -1
            if !last_purge_exists
                call s:PurgeTimestamp(dir)
            endif
            echohl WarningMsg
            echom "TLib: Please run :call tlib#cache#Purge() to clean up ". dir
            echohl NONE
        endif
    elseif !last_purge_exists
        call s:PurgeTimestamp(dir)
    endif
endf


" Delete old files.
function! tlib#cache#Purge() "{{{3
    let threshold = localtime() - g:tlib#cache#purge_days * g:tlib#date#dayshift
    let dir = tlib#cache#Dir('g')
    if g:tlib#cache#verbosity >= 1
        echohl WarningMsg
        echom "TLib: Delete files older than ". g:tlib#cache#purge_days ." days from ". dir
        echohl NONE
    endif
    let files = tlib#cache#ListFilesInCache()
    let deldir = []
    let newer = []
    let msg = []
    let more = &more
    set nomore
    try
        for file in files
            if isdirectory(file)
                if empty(filter(copy(newer), 'strpart(v:val, 0, len(file)) ==# file'))
                    call add(deldir, file)
                endif
            else
                if getftime(file) < threshold
                    if delete(file)
                        call add(msg, "TLib: Could not delete cache file: ". file)
                    elseif g:tlib#cache#verbosity >= 2
                        call add(msg, "TLib: Delete cache file: ". file)
                    endif
                else
                    call add(newer, file)
                endif
            endif
        endfor
    finally
        let &more = more
    endtry
    if !empty(msg) && g:tlib#cache#verbosity >= 1
        echo join(msg, "\n")
    endif
    if !empty(deldir)
        if &shell =~ 'sh\(\.exe\)\?$'
            let scriptfile = 'deldir.sh'
            let rmdir = 'rm -rf %s'
        else
            let scriptfile = 'deldir.bat'
            let rmdir = 'rmdir /S /Q %s'
        endif
        let enc = g:tlib#cache#script_encoding
        if has('multi_byte') && enc != &enc
            call map(deldir, 'iconv(v:val, &enc, enc)')
        endif
        let scriptfile = tlib#file#Join([dir, scriptfile])
        if filereadable(scriptfile)
            let script = readfile(scriptfile)
        else
            let script = []
        endif
        let script += map(copy(deldir), 'printf(rmdir, shellescape(v:val, 1))')
        let script = tlib#list#Uniq(script)
        call writefile(script, scriptfile)
        call inputsave()
        if g:tlib#cache#run_script == 0
            if g:tlib#cache#verbosity >= 1
                echohl WarningMsg
                if g:tlib#cache#verbosity >= 2
                    echom "TLib: Purged cache. Need to run script to delete directories"
                endif
                echom "TLib: Please review and execute: ". scriptfile
                echohl NONE
            endif
        else
            try
                let yn = g:tlib#cache#run_script == 2 ? 'y' : tlib#input#Dialog("TLib: About to delete directories by means of a shell script.\nDirectory removal script: ". scriptfile ."\nRun script to delete directories now?", ['yes', 'no', 'edit'], 'no')
                if yn =~ '^y\%[es]$'
                    exec 'cd '. fnameescape(dir)
                    exec '! ' &shell shellescape(scriptfile, 1)
                    exec 'cd -'
                    call delete(scriptfile)
                elseif yn =~ '^e\%[dit]$'
                    exec 'edit '. fnameescape(scriptfile)
                endif
            finally
                call inputrestore()
            endtry
        endif
    endif
    call s:PurgeTimestamp(dir)
endf


function! s:PurgeTimestamp(dir) "{{{3
    let last_purge = tlib#file#Join([a:dir, '.last_purge'])
    " TLogVAR last_purge
    call writefile([" "], last_purge)
endf

function! tlib#cache#ListFilesInCache(...) "{{{3
    let dir = a:0 >= 1 ? a:1 : tlib#cache#Dir('g')
    if v:version > 702 || (v:version == 702 && has('patch51'))
        let filess = glob(tlib#file#Join([dir, '**']), 1)
    else
        let filess = glob(tlib#file#Join([dir, '**']))
    endif
    let files = reverse(split(filess, '\n'))
    let pos0 = len(tlib#dir#CanonicName(dir))
    call filter(files, 's:ShouldPurge(strpart(v:val, pos0))')
    return files
endf


function! s:ShouldPurge(partial_filename) "{{{3
    " TLogVAR a:partial_filename
    for rx in g:tlib#cache#dont_purge
        if a:partial_filename =~ rx
            " TLogVAR a:partial_filename, rx
            return 0
        endif
    endfor
    return 1
endf

autoload/tlib/normal.vim	[[[1
34
" normal.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-10-06.
" @Last Change: 2010-09-22.
" @Revision:    28

let s:save_cpo = &cpo
set cpo&vim


" :display: tlib#normal#WithRegister(cmd, ?register='t', ?norm_cmd='norm!')
" Execute a normal command while maintaining all registers.
function! tlib#normal#WithRegister(cmd, ...) "{{{3
    TVarArg ['register', 't'], ['norm_cmd', 'norm!']
    let registers = {}
    for reg in split('123456789'. register, '\zs')
        exec 'let registers[reg] = @'. reg
    endfor
    exec 'let reg = @'. register
    try
        exec norm_cmd .' '. a:cmd
        exec 'return @'. register
    finally
        for [reg, value] in items(registers)
            exec 'let @'. reg .' = value'
        endfor
    endtry
endf


let &cpo = s:save_cpo
unlet s:save_cpo
autoload/tlib/time.vim	[[[1
60
" time.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-10-17.
" @Last Change: 2009-02-22.
" @Revision:    0.0.29

if &cp || exists("loaded_tlib_time_autoload")
    finish
endif
let loaded_tlib_time_autoload = 1


function! tlib#time#MSecs() "{{{3
    let rts = reltimestr(reltime())
    return substitute(rts, '\.', '', '')
endf


function! tlib#time#Now() "{{{3
    let rts = reltimestr(reltime())
    let rtl = split(rts, '\.')
    return rtl
endf


function! tlib#time#Diff(a, b, ...) "{{{3
    TVarArg ['resolution', 2]
    let [as, am] = a:a
    let [bs, bm] = a:b
    let rv = 0 + (as - bs)
    if resolution > 0
        let rv .= repeat('0', resolution)
        let am = am[0 : resolution - 1]
        let bm = bm[0 : resolution - 1]
        let rv += (am - bm)
    endif
    return rv
endf


function! tlib#time#DiffMSecs(a, b, ...) "{{{3
    TVarArg ['resolution', 2]
    if a:a == a:b
        return 0
    endif
    let a = printf('%30s', a:a[0 : -(7 - resolution)])
    let b = printf('%30s', a:b[0 : -(7 - resolution)])
    for i in range(0, 29)
        if a[i] != b[i]
            let a = a[i : -1]
            let b = b[i : -1]
            return a - b
        endif
    endfor
    return 0
endf


autoload/tlib/var.vim	[[[1
85
" var.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2009-02-15.
" @Revision:    0.0.23

if &cp || exists("loaded_tlib_var_autoload")
    finish
endif
let loaded_tlib_var_autoload = 1


" Define a variable called NAME if yet undefined.
" You can also use the :TLLet command.
"
" EXAMPLES: >
"   exec tlib#var#Let('g:foo', 1)
"   TLet g:foo = 1
function! tlib#var#Let(name, val) "{{{3
    return printf('if !exists(%s) | let %s = %s | endif', string(a:name), a:name, string(a:val))
    " return printf('if !exists(%s) | let %s = %s | endif', string(a:name), a:name, a:val)
endf


" :def: function! tlib#var#EGet(var, namespace, ?default='')
" Retrieve a variable by searching several namespaces.
"
" EXAMPLES: >
"   let g:foo = 1
"   let b:foo = 2
"   let w:foo = 3
"   echo eval(tlib#var#EGet('foo', 'vg'))  => 1
"   echo eval(tlib#var#EGet('foo', 'bg'))  => 2
"   echo eval(tlib#var#EGet('foo', 'wbg')) => 3
function! tlib#var#EGet(var, namespace, ...) "{{{3
    let pre  = []
    let post = []
    for namespace in split(a:namespace, '\zs')
        let var = namespace .':'. a:var
        call add(pre,  printf('exists("%s") ? %s : (', var, var))
        call add(post, ')')
    endfor
    let default = a:0 >= 1 ? a:1 : ''
    return join(pre) . string(default) . join(post)
endf


" :def: function! tlib#var#Get(var, namespace, ?default='')
" Retrieve a variable by searching several namespaces.
"
" EXAMPLES: >
"   let g:foo = 1
"   let b:foo = 2
"   let w:foo = 3
"   echo tlib#var#Get('foo', 'bg')  => 1
"   echo tlib#var#Get('foo', 'bg')  => 2
"   echo tlib#var#Get('foo', 'wbg') => 3
function! tlib#var#Get(var, namespace, ...) "{{{3
    for namespace in split(a:namespace, '\zs')
        let var = namespace .':'. a:var
        if exists(var)
            return eval(var)
        endif
    endfor
    return a:0 >= 1 ? a:1 : ''
endf


" :def: function! tlib#var#List(rx, ?prefix='')
" Get a list of variables matching rx.
" EXAMPLE:
"   echo tlib#var#List('tlib_', 'g:')
function! tlib#var#List(rx, ...) "{{{3
    TVarArg ['prefix', '']
    redir => vars
    silent! exec 'let '. prefix
    redir END
    let varlist = split(vars, '\n')
    call map(varlist, 'matchstr(v:val, ''^\S\+'')')
    call filter(varlist, 'v:val =~ a:rx')
    return varlist
endf

autoload/tlib/agent.vim	[[[1
614
" agent.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-24.
" @Last Change: 2014-02-06.
" @Revision:    0.1.251


" :filedoc:
" Various agents for use as key handlers in tlib#input#List()

" Number of items to move when pressing <c-up/down> in the input list window.
TLet g:tlib_scroll_lines = 10


" General {{{1

function! tlib#agent#Exit(world, selected) "{{{3
    if a:world.key_mode == 'default'
        call a:world.CloseScratch()
        let a:world.state = 'exit empty escape'
        let a:world.list = []
        " let a:world.base = []
        call a:world.ResetSelected()
    else
        let a:world.key_mode = 'default'
        let a:world.state = 'redisplay'
    endif
    return a:world
endf


function! tlib#agent#CopyItems(world, selected) "{{{3
    let @* = join(a:selected, "\n")
    let a:world.state = 'redisplay'
    return a:world
endf



" InputList related {{{1

function! tlib#agent#PageUp(world, selected) "{{{3
    let a:world.offset -= (winheight(0) / 2)
    let a:world.state = 'scroll'
    return a:world
endf


function! tlib#agent#PageDown(world, selected) "{{{3
    let a:world.offset += (winheight(0) / 2)
    let a:world.state = 'scroll'
    return a:world
endf


function! tlib#agent#Home(world, selected) "{{{3
    let a:world.prefidx = 1
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#End(world, selected) "{{{3
    let a:world.prefidx = len(a:world.list)
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#Up(world, selected, ...) "{{{3
    TVarArg ['lines', 1]
    let a:world.idx = ''
    if a:world.prefidx > lines
        let a:world.prefidx -= lines
    else
        let a:world.prefidx = len(a:world.list)
    endif
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#Down(world, selected, ...) "{{{3
    TVarArg ['lines', 1]
    let a:world.idx = ''
    if a:world.prefidx <= (len(a:world.list) - lines)
        let a:world.prefidx += lines
    else
        let a:world.prefidx = 1
    endif
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#UpN(world, selected) "{{{3
    return tlib#agent#Up(a:world, a:selected, g:tlib_scroll_lines)
endf


function! tlib#agent#DownN(world, selected) "{{{3
    return tlib#agent#Down(a:world, a:selected, g:tlib_scroll_lines)
endf


function! tlib#agent#ShiftLeft(world, selected) "{{{3
    let a:world.offset_horizontal -= (winwidth(0) / 2)
    if a:world.offset_horizontal < 0
        let a:world.offset_horizontal = 0
    endif
    let a:world.state = 'display shift'
    return a:world
endf


function! tlib#agent#ShiftRight(world, selected) "{{{3
    let a:world.offset_horizontal += (winwidth(0) / 2)
    let a:world.state = 'display shift'
    return a:world
endf


function! tlib#agent#Reset(world, selected) "{{{3
    let a:world.state = 'reset'
    return a:world
endf


function! tlib#agent#ToggleRestrictView(world, selected) "{{{3
    if empty(a:world.filtered_items)
        return tlib#agent#RestrictView(a:world, a:selected)
    else
        return tlib#agent#UnrestrictView(a:world, a:selected)
    endif
endf


function! tlib#agent#RestrictView(world, selected) "{{{3
    " TLogVAR a:selected
    let filtered_items = map(copy(a:selected), 'index(a:world.base, v:val) + 1')
    " TLogVAR 1, filtered_items
    let filtered_items = filter(filtered_items, 'v:val > 0')
    " TLogVAR 2, filtered_items
    if !empty(filtered_items)
        let a:world.filtered_items = filtered_items
    endif
    let a:world.state = 'display'
    return a:world
endf


function! tlib#agent#UnrestrictView(world, selected) "{{{3
    let a:world.filtered_items = []
    let a:world.state = 'display'
    return a:world
endf


function! tlib#agent#Input(world, selected) "{{{3
    let flt0 = a:world.CleanFilter(a:world.filter[0][0])
    let flt1 = input('Filter: ', flt0)
    echo
    if flt1 != flt0
        if empty(flt1)
            call getchar(0)
        else
            call a:world.SetFrontFilter(flt1)
        endif
    endif
    let a:world.state = 'display'
    return a:world
endf


" Suspend (see |tlib#agent#Suspend|) the input loop and jump back to the 
" original position in the parent window.
function! tlib#agent#SuspendToParentWindow(world, selected) "{{{3
    let world = a:world
    let winnr = world.win_wnr
    " TLogVAR winnr
    if winnr != -1
        let world = tlib#agent#Suspend(world, a:selected)
        if world.state =~ '\<suspend\>'
            call world.SwitchWindow('win')
            " let pos = world.cursor
            " " TLogVAR pos
            " if !empty(pos)
            "     call setpos('.', pos)
            " endif
            return world
        endif
    endif
    let world.state = 'redisplay'
    return world
endf


" Suspend lets you temporarily leave the input loop of 
" |tlib#input#List|. You can resume editing the list by pressing <c-z>, 
" <m-z>. <space>, <c-LeftMouse> or <MiddleMouse> in the suspended window.
" <cr> and <LeftMouse> will immediatly select the item under the cursor.
" < will select the item but the window will remain opened.
function! tlib#agent#Suspend(world, selected) "{{{3
    if a:world.allow_suspend
        " TAssert IsNotEmpty(a:world.scratch)
        " TLogDBG bufnr('%')
        let br = tlib#buffer#Set(a:world.scratch)
        " TLogVAR br, a:world.bufnr, a:world.scratch
        if bufnr('%') != a:world.scratch
            echohl WarningMsg
            echom "tlib#agent#Suspend: Internal error: Not a scratch buffer:" bufname('%')
            echohl NONE
        endif
        " TLogVAR bufnr('%'), bufname('%'), a:world.scratch
        call tlib#autocmdgroup#Init()
        exec 'autocmd TLib BufEnter <buffer='. a:world.scratch .'> call tlib#input#Resume("world", 0, '. a:world.scratch .')'
        let b:tlib_world = a:world
        exec br
        let a:world.state = 'exit suspend'
    else
        echom 'Suspend disabled'
        let a:world.state = 'redisplay'
    endif
    return a:world
endf


function! tlib#agent#Help(world, selected) "{{{3
    let a:world.state = 'help'
    return a:world
endf


function! tlib#agent#OR(world, selected) "{{{3
    if !empty(a:world.filter[0])
        call insert(a:world.filter[0], '')
    endif
    let a:world.state = 'display'
    return a:world
endf


function! tlib#agent#AND(world, selected) "{{{3
    if !empty(a:world.filter[0])
        call insert(a:world.filter, [''])
    endif
    let a:world.state = 'display'
    return a:world
endf


function! tlib#agent#ReduceFilter(world, selected) "{{{3
    call a:world.ReduceFilter()
    let a:world.offset = 1
    let a:world.state = 'display'
    return a:world
endf


function! tlib#agent#PopFilter(world, selected) "{{{3
    call a:world.PopFilter()
    let a:world.offset = 1
    let a:world.state = 'display'
    return a:world
endf


function! tlib#agent#Debug(world, selected) "{{{3
    " echo string(world.state)
    echo string(a:world.filter)
    echo string(a:world.idx)
    echo string(a:world.prefidx)
    echo string(a:world.sel_idx)
    call getchar()
    let a:world.state = 'display'
    return a:world
endf


function! tlib#agent#Select(world, selected) "{{{3
    call a:world.SelectItem('toggle', a:world.prefidx)
    " let a:world.state = 'display keepcursor'
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#SelectUp(world, selected) "{{{3
    call a:world.SelectItem('toggle', a:world.prefidx)
    if a:world.prefidx > 1
        let a:world.prefidx -= 1
    endif
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#SelectDown(world, selected) "{{{3
    call a:world.SelectItem('toggle', a:world.prefidx)
    if a:world.prefidx < len(a:world.list)
        let a:world.prefidx += 1
    endif
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#SelectAll(world, selected) "{{{3
    let listrange = range(1, len(a:world.list))
    let mode = empty(filter(copy(listrange), 'index(a:world.sel_idx, a:world.GetBaseIdx(v:val)) == -1'))
                \ ? 'toggle' : 'set'
    for i in listrange
        call a:world.SelectItem(mode, i)
    endfor
    let a:world.state = 'display keepcursor'
    return a:world
endf


function! tlib#agent#ToggleStickyList(world, selected) "{{{3
    let a:world.sticky = !a:world.sticky
    let a:world.state = 'display keepcursor'
    return a:world
endf



" EditList related {{{1

function! tlib#agent#EditItem(world, selected) "{{{3
    let lidx = a:world.prefidx
    " TLogVAR lidx
    " TLogVAR a:world.table
    let bidx = a:world.GetBaseIdx(lidx)
    " TLogVAR bidx
    let item = a:world.GetBaseItem(bidx)
    let item = input(lidx .'@'. bidx .': ', item)
    if item != ''
        call a:world.SetBaseItem(bidx, item)
    endif
    let a:world.state = 'display'
    return a:world
endf


" Insert a new item below the current one.
function! tlib#agent#NewItem(world, selected) "{{{3
    let basepi = a:world.GetBaseIdx(a:world.prefidx)
    let item = input('New item: ')
    call insert(a:world.base, item, basepi)
    let a:world.state = 'reset'
    return a:world
endf


function! tlib#agent#DeleteItems(world, selected) "{{{3
    let remove = copy(a:world.sel_idx)
    let basepi = a:world.GetBaseIdx(a:world.prefidx)
    if index(remove, basepi) == -1
        call add(remove, basepi)
    endif
    " call map(remove, 'a:world.GetBaseIdx(v:val)')
    for idx in reverse(sort(remove))
        call remove(a:world.base, idx - 1)
    endfor
    let a:world.state = 'display'
    call a:world.ResetSelected()
    " let a:world.state = 'reset'
    return a:world
endf


function! tlib#agent#Cut(world, selected) "{{{3
    let world = tlib#agent#Copy(a:world, a:selected)
    return tlib#agent#DeleteItems(world, a:selected)
endf


function! tlib#agent#Copy(world, selected) "{{{3
    let a:world.clipboard = []
    let bidxs = copy(a:world.sel_idx)
    call add(bidxs, a:world.GetBaseIdx(a:world.prefidx))
    for bidx in sort(bidxs)
        call add(a:world.clipboard, a:world.GetBaseItem(bidx))
    endfor
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#Paste(world, selected) "{{{3
    if has_key(a:world, 'clipboard')
        for e in reverse(copy(a:world.clipboard))
            call insert(a:world.base, e, a:world.prefidx)
        endfor
    endif
    let a:world.state = 'display'
    call a:world.ResetSelected()
    return a:world
endf


function! tlib#agent#EditReturnValue(world, rv) "{{{3
    return [a:world.state !~ '\<exit\>', a:world.base]
endf



" Files related {{{1

function! tlib#agent#ViewFile(world, selected) "{{{3
    if !empty(a:selected)
        let back = a:world.SwitchWindow('win')
        " TLogVAR back
        if !&hidden && &l:modified
            let cmd0 = 'split'
            let cmd1 = 'sbuffer'
        else
            let cmd0 = 'edit'
            let cmd1 = 'buffer'
        endif
        call tlib#file#With(cmd0, cmd1, a:selected, a:world)
        " TLogVAR &filetype
        exec back
        let a:world.state = 'display'
    endif
    return a:world
endf


function! tlib#agent#EditFile(world, selected) "{{{3
    return tlib#agent#Exit(tlib#agent#ViewFile(a:world, a:selected), a:selected)
endf


function! tlib#agent#EditFileInSplit(world, selected) "{{{3
    call a:world.CloseScratch()
    " call tlib#file#With('edit', 'buffer', a:selected[0:0], a:world)
    " call tlib#file#With('split', 'sbuffer', a:selected[1:-1], a:world)
    call tlib#file#With('split', 'sbuffer', a:selected, a:world)
    return tlib#agent#Exit(a:world, a:selected)
endf


function! tlib#agent#EditFileInVSplit(world, selected) "{{{3
    call a:world.CloseScratch()
    " call tlib#file#With('edit', 'buffer', a:selected[0:0], a:world)
    " call tlib#file#With('vertical split', 'vertical sbuffer', a:selected[1:-1], a:world)
    let winpos = tlib#fixes#Winpos()
    call tlib#file#With('vertical split', 'vertical sbuffer', a:selected, a:world)
    if !empty(winpos)
        exec winpos
    endif
    return tlib#agent#Exit(a:world, a:selected)
endf


function! tlib#agent#EditFileInTab(world, selected) "{{{3
    " TLogVAR a:selected
    call a:world.CloseScratch()
    call tlib#file#With('tabedit', 'tab sbuffer', a:selected, a:world)
    return tlib#agent#Exit(a:world, a:selected)
endf


function! tlib#agent#ToggleScrollbind(world, selected) "{{{3
    let a:world.scrollbind = get(a:world, 'scrollbind') ? 0 : 1
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#ShowInfo(world, selected)
    let lines = []
    for f in a:selected
        if filereadable(f)
            let desc = [getfperm(f), strftime('%c', getftime(f)),  getfsize(f) .' bytes', getftype(f)]
            call add(lines, fnamemodify(f, ':p'))
            call add(lines, '  '. join(desc, '; '))
        endif
    endfor
    let a:world.temp_lines = lines
    let a:world.state = 'printlines'
    return a:world
endf



" Buffer related {{{1

function! tlib#agent#PreviewLine(world, selected) "{{{3
    let l = a:selected[0]
    let ww = winnr()
    exec a:world.win_wnr .'wincmd w'
    call tlib#buffer#ViewLine(l, 1)
    exec ww .'wincmd w'
    let a:world.state = 'redisplay'
    return a:world
endf


" If not called from the scratch, we assume/guess that we don't have to 
" suspend the input-evaluation loop.
function! tlib#agent#GotoLine(world, selected) "{{{3
    if !empty(a:selected)

        " let l = a:selected[0]
        " " TLogVAR l
        " let back = a:world.SwitchWindow('win')
        " " TLogVAR back
        " " if a:world.win_wnr != winnr()
        " "     let world = tlib#agent#Suspend(a:world, a:selected)
        " "     exec a:world.win_wnr .'wincmd w'
        " " endif
        " call tlib#buffer#ViewLine(l)
        " exec back
        " let a:world.state = 'display'

        let l = a:selected[0]
        if a:world.win_wnr != winnr()
            let world = tlib#agent#Suspend(a:world, a:selected)
            exec a:world.win_wnr .'wincmd w'
        endif
        call tlib#buffer#ViewLine(l, 1)
        
    endif
    return a:world
endf


function! tlib#agent#DoAtLine(world, selected) "{{{3
    if !empty(a:selected)
        let cmd = input('Command: ', '', 'command')
        if !empty(cmd)
            call a:world.SwitchWindow('win')
            " let pos = getpos('.')
            let view = winsaveview()
            for l in a:selected
                call tlib#buffer#ViewLine(l, '')
                exec cmd
            endfor
            " call setpos('.', pos)
            call winrestview(view)
        endif
    endif
    call a:world.ResetSelected()
    let a:world.state = 'exit'
    return a:world
endf


function! tlib#agent#Wildcard(world, selected) "{{{3
    if !empty(a:world.filter[0])
        let rx_type = a:world.matcher.FilterRxPrefix()
        let flt0 = a:world.CleanFilter(a:world.filter[0][0])
        if rx_type == '\V'
            let flt0 .= '\.\{-}'
        else
            let flt0 .= '.\{-}'
        endif
        call a:world.SetFrontFilter(flt0)
    endif
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#Null(world, selected) "{{{3
    let a:world.state = 'redisplay'
    return a:world
endf


function! tlib#agent#ExecAgentByName(world, selected) "{{{3
    let s:agent_names_world = a:world
    let agent_names = {'Help': 'tlib#agent#Help'}
    for def in values(a:world.key_map[a:world.key_mode])
        if has_key(def, 'help') && !empty(def.help) && has_key(def, 'agent') && !empty(def.agent)
            let agent_names[def.help] = def.agent
        endif
    endfor
    let s:agent_names = sort(keys(agent_names))
    let command = input('Command: ', '', 'customlist,tlib#agent#CompleteAgentNames')
    " TLogVAR command
    if !has_key(agent_names, command)
        " TLogVAR command
        silent! let matches = filter(keys(agent_names), 'v:val =~ command')
        " TLogVAR matches
        if len(matches) == 1
            let command = matches[0]
        endif
    endif
    if has_key(agent_names, command)
        let agent = agent_names[command]
        return call(agent, [a:world, a:selected])
    else
        if !empty(command)
            echohl WarningMsg
            echom "Unknown command:" command
            echohl NONE
            sleep 1
        endif
        let a:world.state = 'display'
        return a:world
    endif
endf


function! tlib#agent#CompleteAgentNames(ArgLead, CmdLine, CursorPos)
    return filter(copy(s:agent_names), 'stridx(v:val, a:ArgLead) != -1')
endf

autoload/tlib/bitwise.vim	[[[1
141
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    124


function! tlib#bitwise#Num2Bits(num) "{{{3
    if type(a:num) <= 1 || type(a:num) == 5
        let bits = reverse(tlib#number#ConvertBase(a:num, 2, 'list'))
    elseif type(a:num) == 3
        let bits = copy(a:num)
    else
        throw "tlib#bitwise#Num2Bits: Must be number of list: ". string(a:num)
    endif
    return bits
endf


function! tlib#bitwise#Bits2Num(bits, ...) "{{{3
    let base = a:0 >= 1 ? a:1 : 10
    " TLogVAR a:bits
    let num = 0.0
    for i in range(len(a:bits))
        if get(a:bits, i, 0)
            let num += pow(2, i)
        endif
    endfor
    " TLogVAR num
    if base == 10
        if type(base) == 5
            return num
        else
            return float2nr(num)
        endif
    else
        return tlib#number#ConvertBase(num, base)
    endif
endf


function! tlib#bitwise#AND(num1, num2, ...) "{{{3
    let rtype = a:0 >= 1 ? a:1 : 'num'
    return s:BitwiseComparison(a:num1, a:num2, rtype,
                \ 'get(bits1, v:val) && get(bits2, v:val)')
endf


function! tlib#bitwise#OR(num1, num2, ...) "{{{3
    let rtype = a:0 >= 1 ? a:1 : 'num'
    return s:BitwiseComparison(a:num1, a:num2, rtype,
                \ 'get(bits1, v:val) || get(bits2, v:val)')
endf


function! tlib#bitwise#XOR(num1, num2, ...) "{{{3
    let rtype = a:0 >= 1 ? a:1 : 'num'
    return s:BitwiseComparison(a:num1, a:num2, rtype,
                \ 'get(bits1, v:val) ? !get(bits2, v:val) : get(bits2, v:val)')
endf


function! s:BitwiseComparison(num1, num2, rtype, expr) "{{{3
    let bits1 = tlib#bitwise#Num2Bits(a:num1)
    let bits2 = tlib#bitwise#Num2Bits(a:num2)
    let range = range(max([len(bits1), len(bits2)]))
    let bits = map(range, a:expr)
    if a:rtype == 'num' || (a:rtype == 'auto' && type(a:num1) <= 1)
        return tlib#bitwise#Bits2Num(bits)
    else
        return bits
    endif
endf


function! tlib#bitwise#ShiftRight(bits, n) "{{{3
    let bits = a:bits[a:n : -1]
    if empty(bits)
        let bits = [0]
    endif
    return bits
endf


function! tlib#bitwise#ShiftLeft(bits, n) "{{{3
    let bits = repeat([0], a:n) + a:bits
    return bits
endf


function! tlib#bitwise#Add(num1, num2, ...) "{{{3
    let rtype = a:0 >= 1 ? a:1 : 'num'
    let bits1 = tlib#bitwise#Num2Bits(a:num1)
    let bits2 = tlib#bitwise#Num2Bits(a:num2)
    let range = range(max([len(bits1), len(bits2)]))
    " TLogVAR bits1, bits2, range
    let carry = 0
    let bits  = []
    for i in range
        let sum = get(bits1, i) + get(bits2, i) + carry
        if sum == 3
            let bit = 1
            let carry = 1
        elseif sum == 2
            let bit = 0
            let carry = 1
        elseif sum == 1
            let bit = 1
            let carry = 0
        elseif sum == 0
            let bit = 0
            let carry = 0
        endif
        call add(bits, bit)
        " TLogVAR i, bits, bit
    endfor
    if carry == 1
        call add(bits, carry)
    endif
    if rtype == 'num' || (rtype == 'auto' && type(a:num1) <= 1)
        return tlib#bitwise#Bits2Num(bits)
    else
        return bits
    endif
endf


function! tlib#bitwise#Sub(num1, num2, ...) "{{{3
    let rtype = a:0 >= 1 ? a:1 : 'num'
    let bits1 = tlib#bitwise#Num2Bits(a:num1)
    let bits2 = tlib#bitwise#Num2Bits(a:num2)
    let range = range(max([len(bits1), len(bits2)]))
    let bits2 = map(range, '!get(bits2, v:val)')
    let bits2 = tlib#bitwise#Add(bits2, [1], 'bits')
    let bits3 = tlib#bitwise#Add(bits1, bits2, 'bits')
    let bits = bits3[0 : -2]
    if rtype == 'num' || (rtype == 'auto' && type(a:num1) <= 1)
        return tlib#bitwise#Bits2Num(bits)
    else
        return bits
    endif
endf

autoload/tlib/url.vim	[[[1
52
" url.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2011-03-10.
" @Revision:    0.0.28


" TODO: These functions could use printf() now.

" Decode an encoded URL.
function! tlib#url#Decode(url) "{{{3
    return substitute(a:url, '\(+\|%\(%\|\x\x\)\)', '\=tlib#url#DecodeChar(submatch(1))', 'g')
endf


" Decode a single character.
function! tlib#url#DecodeChar(char) "{{{3
    if a:char == '%%'
        return '%'
    elseif a:char == '+'
        return ' '
    else
        return nr2char("0x".a:char[1 : -1])
    endif
endf


" Encode a single character.
function! tlib#url#EncodeChar(char) "{{{3
    if a:char == '%'
        return '%%'
    elseif a:char == ' '
        return '+'
    else
        return printf("%%%X", char2nr(a:char))
    endif
endf


" Encode an URL.
function! tlib#url#Encode(url, ...) "{{{3
    TVarArg ['extrachars', '']
    let rx = '\([^a-zA-Z0-9_.'. extrachars .'-]\)'
    " TLogVAR a:url, rx
    let rv = substitute(a:url, rx, '\=tlib#url#EncodeChar(submatch(1))', 'g')
    " TLogVAR rv
    return rv
endf


autoload/tlib/signs.vim	[[[1
103
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2009-03-12.
" @Last Change: 2011-03-10.
" @Revision:    0.0.45

let s:save_cpo = &cpo
set cpo&vim


let s:base = 2327
let s:register = {}


" Clear all signs with name SIGN.
function! tlib#signs#ClearAll(sign) "{{{3
    " TLog a:sign
    for bn in keys(s:register)
        let idxs = keys(s:register)
        call filter(idxs, 's:register[v:val].sign == a:sign')
        " TLogVAR bns
        for idx in idxs
            exec 'sign unplace '. idx .' buffer='. s:register[idx].bn
            call remove(s:register, idx)
        endfor
    endfor
endf


" Clear all signs with name SIGN in buffer BUFNR.
function! tlib#signs#ClearBuffer(sign, bufnr) "{{{3
    for bn in keys(s:register)
        let idxs = keys(s:register)
        call filter(idxs, 's:register[v:val].sign == a:sign && s:register[v:val].bn == a:bufnr')
        " TLogVAR bns
        for idx in idxs
            exec 'sign unplace '. idx .' buffer='. s:register[idx].bn
            call remove(s:register, idx)
        endfor
    endfor
endf


" function! tlib#signs#Clear(sign, list) "{{{3
"     " TLogVAR a:sign
"     let done = []
"     for item in a:list
"         let bn = get(item, 'bufnr', -1)
"         if index(done, bn) == -1
"             let idxs = keys(s:register)
"             call filter(idxs, 's:register[v:val].sign == a:sign && s:register[v:val].bn == bn')
"             for idx in idxs
"                 exec 'sign unplace '. idx .' buffer='. s:register[idx].bn
"                 call remove(s:register, idx)
"             endfor
"             call add(done, bn)
"         endif
"     endfor
" endf


" Add signs for all locations in LIST. LIST must adhere with the 
" quickfix list format (see |getqflist()|; only the fields lnum and 
" bufnr are required).
"
" list:: a quickfix or location list
" sign:: a sign defined with |:sign-define|
function! tlib#signs#Mark(sign, list) "{{{3
    " TLogVAR a:sign
    for item in a:list
        let idx = s:SignId(item)
        if idx >= 0
            let lnum = get(item, 'lnum', 0)
            if lnum > 0
                let bn = get(item, 'bufnr')
                exec ':sign place '. idx .' line='. lnum .' name='. a:sign .' buffer='. bn
                let s:register[idx] = {'sign': a:sign, 'bn': bn}
            endif
        endif
    endfor
endf


function! s:SignId(item) "{{{3
    " TLogVAR a:item
    " let bn  = bufnr('%')
    let bn = get(a:item, 'bufnr', -1)
    if bn == -1
        return -1
    else
        let idx = s:base + bn * 500
        while has_key(s:register, idx)
            let idx += 1
        endwh
        return idx
    endif
endf



let &cpo = s:save_cpo
unlet s:save_cpo
autoload/tlib/rx.vim	[[[1
63
" rx.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-07-20.
" @Last Change: 2010-02-26.
" @Revision:    0.0.28

if &cp || exists("loaded_tlib_rx_autoload")
    finish
endif
let loaded_tlib_rx_autoload = 1


" :def: function! tlib#rx#Escape(text, ?magic='m')
" magic can be one of: m, M, v, V
" See :help 'magic'
function! tlib#rx#Escape(text, ...) "{{{3
    TVarArg 'magic'
    if empty(magic)
        let magic = 'm'
    endif
    if magic =~# '^\\\?m$'
        return escape(a:text, '^$.*\[]~')
    elseif magic =~# '^\\\?M$'
        return escape(a:text, '^$\')
    elseif magic =~# '^\\\?V$'
        return escape(a:text, '\')
    elseif magic =~# '^\\\?v$'
        return substitute(a:text, '[^0-9a-zA-Z_]', '\\&', 'g')
    else
        echoerr 'tlib: Unsupported magic type'
        return a:text
    endif
endf

" :def: function! tlib#rx#EscapeReplace(text, ?magic='m')
" Escape return |sub-replace-special|.
function! tlib#rx#EscapeReplace(text, ...) "{{{3
    TVarArg ['magic', 'm']
    if magic ==# 'm' || magic ==# 'v'
        return escape(a:text, '\&~')
    elseif magic ==# 'M' || magic ==# 'V'
        return escape(a:text, '\')
    else
        echoerr 'magic must be one of: m, v, M, V'
    endif
endf


function! tlib#rx#Suffixes(...) "{{{3
    TVarArg ['magic', 'm']
    let sfx = split(&suffixes, ',')
    call map(sfx, 'tlib#rx#Escape(v:val, magic)')
    if magic ==# 'v'
        return '('. join(sfx, '|') .')$'
    elseif magic ==# 'V'
        return '\('. join(sfx, '\|') .'\)\$'
    else
        return '\('. join(sfx, '\|') .'\)$'
    endif
endf

autoload/tlib/tag.vim	[[[1
140
" tag.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-11-01.
" @Last Change: 2013-09-25.
" @Revision:    0.0.58

if &cp || exists("loaded_tlib_tag_autoload")
    finish
endif
let loaded_tlib_tag_autoload = 1


" Extra tags for |tlib#tag#Retrieve()| (see there). Can also be buffer-local.
TLet g:tlib_tags_extra = ''

" Filter the tag description through |substitute()| for these filetypes. 
" This applies only if the tag cmd field (see |taglist()|) is used.
" :nodefault:
TLet g:tlib_tag_substitute = {
            \ 'java': [['\s*{\s*$', '', '']],
            \ 'ruby': [['\<\(def\|class\|module\)\>\s\+', '', '']],
            \ 'vim':  [
            \   ['^\s*com\%[mand]!\?\(\s\+-\S\+\)*\s*\u\w*\zs.*$', '', ''],
            \   ['^\s*\(let\|aug\%[roup]\|fu\%[nction]!\?\|com\%[mand]!\?\(\s\+-\S\+\)*\)\s*', '', ''],
            \   ['"\?\s*{{{\d.*$', '', ''],
            \ ],
            \ }


" :def: function! tlib#tag#Retrieve(rx, ?extra_tags=0)
" Get all tags matching rx. Basically, this function simply calls 
" |taglist()|, but when extra_tags is true, the list of the tag files 
" (see 'tags') is temporarily expanded with |g:tlib_tags_extra|.
"
" Example use:
" If you want to include tags for, eg, JDK, normal tags use can become 
" slow. You could proceed as follows:
"     1. Create a tags file for the JDK sources. When creating the tags 
"     file, make sure to include inheritance information and the like 
"     (command-line options like --fields=+iaSm --extra=+q should be ok).
"     In this example, we want tags only for public methods (there are 
"     most likely better ways to do this): >
"          ctags -R --fields=+iaSm --extra=+q ${JAVA_HOME}/src
"          head -n 6 tags > tags0
"          grep access:public tags >> tags0
" <    2. Make 'tags' include project specific tags files. In 
"      ~/vimfiles/after/ftplugin/java.vim insert: >
"          let b:tlib_tags_extra = $JAVA_HOME .'/tags0'
" <    3. When this function is invoked as >
"          echo tlib#tag#Retrieve('print')
" <    it will return only project-local tags. If it is invoked as >
"          echo tlib#tag#Retrieve('print', 1)
" <    tags from the JDK will be included.
function! tlib#tag#Retrieve(rx, ...) "{{{3
    TVarArg ['extra_tags', 0]
    " TLogVAR a:rx, extra_tags
    if extra_tags
        let tags_orig = &l:tags
        if empty(tags_orig)
            setlocal tags<
        endif
        try
            let more_tags = tlib#var#Get('tlib_tags_extra', 'bg')
            if !empty(more_tags)
                let &l:tags .= ','. more_tags
            endif
            let taglist = taglist(a:rx)
        finally
            let &l:tags = tags_orig
        endtry
    else
        let taglist = taglist(a:rx)
    endif
    return taglist
endf


" Retrieve tags that meet the constraints (a dictionnary of fields and 
" regexp, with the exception of the kind field which is a list of chars). 
" For the use of the optional use_extra argument see 
" |tlib#tag#Retrieve()|.
" :def: function! tlib#tag#Collect(constraints, ?use_extra=1, ?match_front=1)
function! tlib#tag#Collect(constraints, ...) "{{{3
    TVarArg ['use_extra', 0], ['match_end', 1], ['match_front', 1]
    " TLogVAR a:constraints, use_extra
    let rx = get(a:constraints, 'name', '')
    if empty(rx) || rx == '*'
        let rx = '.'
    else
        let rxl = ['\C']
        if match_front
            call add(rxl, '^')
        endif
        " call add(rxl, tlib#rx#Escape(rx))
        call add(rxl, rx)
        if match_end
            call add(rxl, '$')
        endif
        let rx = join(rxl, '')
    endif
    " TLogVAR rx, use_extra
    let tags = tlib#tag#Retrieve(rx, use_extra)
    " TLogDBG len(tags)
    for [field, rx] in items(a:constraints)
        if !empty(rx) && rx != '*'
            " TLogVAR field, rx
            if field == 'kind'
                call filter(tags, 'v:val.kind =~ "['. rx .']"')
            elseif field != 'name'
                call filter(tags, '!empty(get(v:val, field)) && get(v:val, field) =~ rx')
            endif
        endif
    endfor
    " TLogVAR tags
    return tags
endf


function! tlib#tag#Format(tag) "{{{3
    if has_key(a:tag, 'signature')
        let name = a:tag.name . a:tag.signature
    elseif a:tag.cmd[0] == '/'
        let name = a:tag.cmd
        let name = substitute(name, '^/\^\?\s*', '', '')
        let name = substitute(name, '\s*\$\?/$', '', '')
        let name = substitute(name, '\s\{2,}', ' ', 'g')
        let tsub = tlib#var#Get('tlib_tag_substitute', 'bg')
        if has_key(tsub, &filetype)
            for [rx, rplc, sub] in tsub[&filetype]
                let name = substitute(name, rx, rplc, sub)
            endfor
        endif
    else
        let name = a:tag.name
    endif
    return name
endf

autoload/tlib/map.vim	[[[1
23
" map.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2009-08-23.
" @Last Change: 2009-08-23.
" @Revision:    0.0.4

let s:save_cpo = &cpo
set cpo&vim


" If |pumvisible()| is true, return "\<c-y>". Otherwise return a:key.
" For use in maps like: >
"   imap <expr> <cr> tlib#map#PumAccept("\<cr>")
function! tlib#map#PumAccept(key) "{{{3
    return pumvisible() ? "\<c-y>" : a:key
endf



let &cpo = s:save_cpo
unlet s:save_cpo
autoload/tlib/Filter_cnfd.vim	[[[1
53
" Filter_cnfd.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-11-25.
" @Last Change: 2014-01-23.
" @Revision:    0.0.57

let s:prototype = tlib#Filter_cnf#New({'_class': ['Filter_cnfd'], 'name': 'cnfd'}) "{{{2
let s:prototype.highlight = g:tlib#input#higroup


" The same as |tlib#Filter_cnf#New()| but a dot is expanded to '\.\{-}'. 
" As a consequence, patterns cannot match dots.
" The pattern is a '/\V' very no-'/magic' regexp pattern.
function! tlib#Filter_cnfd#New(...) "{{{3
    let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
    return object
endf


" :nodoc:
function! s:prototype.Init(world) dict "{{{3
endf


let s:Help = s:prototype.Help

" :nodoc:
function! s:prototype.Help(world) dict "{{{3
    call call(s:Help, [a:world], self)
    call a:world.PushHelp('.', 'Any characters')
endf


" :nodoc:
function! s:prototype.SetFrontFilter(world, pattern) dict "{{{3
    let pattern = substitute(a:pattern, '\.', '\\.\\{-}', 'g')
    let a:world.filter[0] = reverse(split(pattern, '\s*|\s*')) + a:world.filter[0][1 : -1]
endf


" :nodoc:
function! s:prototype.PushFrontFilter(world, char) dict "{{{3
    let a:world.filter[0][0] .= a:char == 46 ? '\.\{-}' : nr2char(a:char)
endf


" :nodoc:
function! s:prototype.CleanFilter(filter) dict "{{{3
    return substitute(a:filter, '\\.\\{-}', '.', 'g')
endf

autoload/tlib/input.vim	[[[1
1281
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    1315


" :filedoc:
" Input-related, select from a list etc.

" If a list is bigger than this value, don't try to be smart when 
" selecting an item. Be slightly faster instead.
" See |tlib#input#List()|.
TLet g:tlib#input#sortprefs_threshold = 200


" If a list contains more items, |tlib#input#List()| does not perform an 
" incremental "live search" but uses |input()| to query the user for a 
" filter. This is useful on slower machines or with very long lists.
TLet g:tlib#input#livesearch_threshold = 1000


" Determine how |tlib#input#List()| and related functions work.
" Can be "glob", "cnf", "cnfd", "seq", or "fuzzy". See:
"   glob ... Like cnf but "*" and "?" (see |g:tlib#Filter_glob#seq|, 
"       |g:tlib#Filter_glob#char|) are interpreted as glob-like 
"       |wildcards| (this is the default method)
"     - Examples:
"         - "f*o" matches "fo", "fxo", and "fxxxoo", but doesn't match 
"           "far".
"     - Otherwise it is a derivate of the cnf method (see below).
"     - See also |tlib#Filter_glob#New()|.
"   cnfd ... Like cnf but "." is interpreted as a wildcard, i.e. it is 
"            expanded to "\.\{-}"
"     - A period character (".") acts as a wildcard as if ".\{-}" (see 
"       |/\{-|) were entered.
"     - Examples:
"         - "f.o" matches "fo", "fxo", and "fxxxoo", but doesn't match 
"           "far".
"     - Otherwise it is a derivate of the cnf method (see below).
"     - See also |tlib#Filter_cnfd#New()|.
"   cnf .... Match substrings
"     - A blank creates an AND conjunction, i.e. the next pattern has to 
"       match too.
"     - A pipe character ("|") creates an OR conjunction, either this or 
"       the next next pattern has to match.
"     - Patterns are very 'nomagic' |regexp| with a |\V| prefix.
"     - A pattern starting with "-" makes the filter exclude items 
"       matching that pattern.
"     - Examples:
"         - "foo bar" matches items that contain the strings "foo" AND 
"           "bar".
"         - "foo|bar boo|far" matches items that contain either ("foo" OR 
"           "bar") AND ("boo" OR "far").
"     - See also |tlib#Filter_cnf#New()|.
"   seq .... Match sequences of characters
"     - |tlib#Filter_seq#New()|
"   fuzzy .. Match fuzzy character sequences
"     - |tlib#Filter_fuzzy#New()|
TLet g:tlib#input#filter_mode = 'glob'


" The highlight group to use for showing matches in the input list 
" window.
" See |tlib#input#List()|.
TLet g:tlib#input#higroup = 'IncSearch'

" When 1, automatically select the last remaining item only if the list 
" had only one item to begin with.
" When 2, automatically select a last remaining item after applying 
" any filters.
" See |tlib#input#List()|.
TLet g:tlib_pick_last_item = 1


" :doc:
" Keys for |tlib#input#List|~

TLet g:tlib#input#and = ' '
TLet g:tlib#input#or  = '|'
TLet g:tlib#input#not = '-'

" When editing a list with |tlib#input#List|, typing these numeric chars 
" (as returned by getchar()) will select an item based on its index, not 
" based on its name. I.e. in the default setting, typing a "4" will 
" select the fourth item, not the item called "4".
" In order to make keys 0-9 filter the items in the list and make 
" <m-[0-9]> select an item by its index, remove the keys 48 to 57 from 
" this dictionary.
" Format: [KEY] = BASE ... the number is calculated as KEY - BASE.
" :nodefault:
TLet g:tlib#input#numeric_chars = {
            \ 176: 176,
            \ 177: 176,
            \ 178: 176,
            \ 179: 176,
            \ 180: 176,
            \ 181: 176,
            \ 182: 176,
            \ 183: 176,
            \ 184: 176,
            \ 185: 176,
            \}
            " \ 48: 48,
            " \ 49: 48,
            " \ 50: 48,
            " \ 51: 48,
            " \ 52: 48,
            " \ 53: 48,
            " \ 54: 48,
            " \ 55: 48,
            " \ 56: 48,
            " \ 57: 48,


" :nodefault:
" The default key bindings for single-item-select list views. If you 
" want to use <c-j>, <c-k> to move the cursor up and down, add these two 
" lines to after/plugin/02tlib.vim: >
"
"   let g:tlib#input#keyagents_InputList_s[10] = 'tlib#agent#Down'  " <c-j>
"   let g:tlib#input#keyagents_InputList_s[11] = 'tlib#agent#Up'    " <c-k>
TLet g:tlib#input#keyagents_InputList_s = {
            \ "\<PageUp>":   'tlib#agent#PageUp',
            \ "\<PageDown>": 'tlib#agent#PageDown',
            \ "\<Home>":     'tlib#agent#Home',
            \ "\<End>":      'tlib#agent#End',
            \ "\<Up>":       'tlib#agent#Up',
            \ "\<Down>":     'tlib#agent#Down',
            \ "\<c-Up>":     'tlib#agent#UpN',
            \ "\<c-Down>":   'tlib#agent#DownN',
            \ "\<Left>":     'tlib#agent#ShiftLeft',
            \ "\<Right>":    'tlib#agent#ShiftRight',
            \ 18:            'tlib#agent#Reset',
            \ 242:           'tlib#agent#Reset',
            \ 17:            'tlib#agent#Input',
            \ 241:           'tlib#agent#Input',
            \ 27:            'tlib#agent#Exit',
            \ 26:            'tlib#agent#Suspend',
            \ 250:           'tlib#agent#Suspend',
            \ 15:            'tlib#agent#SuspendToParentWindow',  
            \ "\<F1>":       'tlib#agent#Help',
            \ "\<F10>":      'tlib#agent#ExecAgentByName',
            \ "\<S-Esc>":    'tlib#agent#ExecAgentByName',
            \ "\<bs>":       'tlib#agent#ReduceFilter',
            \ "\<del>":      'tlib#agent#ReduceFilter',
            \ "\<c-bs>":     'tlib#agent#PopFilter',
            \ "\<m-bs>":     'tlib#agent#PopFilter',
            \ "\<c-del>":    'tlib#agent#PopFilter',
            \ "\<m-del>":    'tlib#agent#PopFilter',
            \ "\<s-space>":  'tlib#agent#Wildcard',
            \ 191:           'tlib#agent#Debug',
            \ char2nr(g:tlib#input#or):  'tlib#agent#OR',
            \ char2nr(g:tlib#input#and): 'tlib#agent#AND',
            \ }
            " \ 63:            'tlib#agent#Help',


" :nodefault:
TLet g:tlib#input#keyagents_InputList_m = {
            \ 35:          'tlib#agent#Select',
            \ "\<s-up>":   'tlib#agent#SelectUp',
            \ "\<s-down>": 'tlib#agent#SelectDown',
            \ 1:           'tlib#agent#SelectAll',
            \ 225:         'tlib#agent#SelectAll',
            \ "\<F9>":     'tlib#agent#ToggleRestrictView',
            \ }
" "\<c-space>": 'tlib#agent#Select'


" :nodefault:
TLet g:tlib#input#handlers_EditList = [
            \ {'key': 5,  'agent': 'tlib#agent#EditItem',    'key_name': '<c-e>', 'help': 'Edit item'},
            \ {'key': 4,  'agent': 'tlib#agent#DeleteItems', 'key_name': '<c-d>', 'help': 'Delete item(s)'},
            \ {'key': 14, 'agent': 'tlib#agent#NewItem',     'key_name': '<c-n>', 'help': 'New item'},
            \ {'key': 24, 'agent': 'tlib#agent#Cut',         'key_name': '<c-x>', 'help': 'Cut item(s)'},
            \ {'key':  3, 'agent': 'tlib#agent#Copy',        'key_name': '<c-c>', 'help': 'Copy item(s)'},
            \ {'key': 22, 'agent': 'tlib#agent#Paste',       'key_name': '<c-v>', 'help': 'Paste item(s)'},
            \ {'pick_last_item': 0},
            \ {'return_agent': 'tlib#agent#EditReturnValue'},
            \ {'help_extra': [
            \      'Submit changes by pressing ENTER or <c-s> or <c-w><cr>',
            \      'Cancel editing by pressing <c-w>c'
            \ ]},
            \ ]


" If true, define a popup menu for |tlib#input#List()| and related 
" functions.
TLet g:tlib#input#use_popup = has('menu') && (has('gui_gtk') || has('gui_gtk2') || has('gui_win32'))


" How to format filenames:
"     l ... Show basenames on the left side, separated from the 
"           directory names
"     r ... Show basenames on the right side
TLet g:tlib#input#format_filename = 'l'


" If g:tlib#input#format_filename == 'r', how much space should be kept 
" free on the right side.
TLet g:tlib#input#filename_padding_r = '&co / 10'


" If g:tlib#input#format_filename == 'l', an expression that 
" |eval()|uates to the maximum display width of filenames.
TLet g:tlib#input#filename_max_width = '&co / 2'


" Functions related to tlib#input#List(type, ...) "{{{2

" :def: function! tlib#input#List(type. ?query='', ?list=[], ?handlers=[], ?default="", ?timeout=0)
" Select a single or multiple items from a list. Return either the list 
" of selected elements or its indexes.
"
" By default, typing numbers will select an item by its index. See 
" |g:tlib#input#numeric_chars| to find out how to change this.
"
" The item is automatically selected if the numbers typed equals the 
" number of digits of the list length. I.e. if a list contains 20 items, 
" typing 1 will first highlight item 1 but it won't select/use it 
" because 1 is an ambiguous input in this context. If you press enter, 
" the first item will be selected. If you press another digit (e.g. 0), 
" item 10 will be selected. Another way to select item 1 would be to 
" type 01. If the list contains only 9 items, typing 1 would select the 
" first item right away.
"
" type can be:
"     s  ... Return one selected element
"     si ... Return the index of the selected element
"     m  ... Return a list of selected elements
"     mi ... Return a list of indexes
"
" Several pattern matching styles are supported. See 
" |g:tlib#input#filter_mode|.
"
" EXAMPLES: >
"   echo tlib#input#List('s', 'Select one item', [100,200,300])
"   echo tlib#input#List('si', 'Select one item', [100,200,300])
"   echo tlib#input#List('m', 'Select one or more item(s)', [100,200,300])
"   echo tlib#input#List('mi', 'Select one or more item(s)', [100,200,300])
"
" See ../samples/tlib/input/tlib_input_list.vim (move the cursor over 
" the filename and press gf) for a more elaborated example.
function! tlib#input#List(type, ...) "{{{3
    exec tlib#arg#Let([
        \ ['query', ''],
        \ ['list', []],
        \ ['handlers', []],
        \ ['rv', ''],
        \ ['timeout', 0],
        \ ])
    " let handlers = a:0 >= 1 ? a:1 : []
    " let rv       = a:0 >= 2 ? a:2 : ''
    " let timeout  = a:0 >= 3 ? a:3 : 0
    " let backchar = ["\<bs>", "\<del>"]

    if a:type =~ '^resume'
        let world = b:tlib_{matchstr(a:type, ' \zs.\+')}
    else
        let world = tlib#World#New({
                    \ 'type': a:type,
                    \ 'base': list,
                    \ 'query': query,
                    \ 'timeout': timeout,
                    \ 'rv': rv,
                    \ 'handlers': handlers,
                    \ })
        let scratch_name     = tlib#list#Find(handlers, 'has_key(v:val, "scratch_name")', '', 'v:val.scratch_name')
        if !empty(scratch_name)
            let world.scratch = scratch_name
        endif
        let world.scratch_vertical = tlib#list#Find(handlers, 'has_key(v:val, "scratch_vertical")', 0, 'v:val.scratch_vertical')
        call world.Set_display_format(tlib#list#Find(handlers, 'has_key(v:val, "display_format")', '', 'v:val.display_format'))
        let world.initial_index    = tlib#list#Find(handlers, 'has_key(v:val, "initial_index")', 1, 'v:val.initial_index')
        let world.index_table      = tlib#list#Find(handlers, 'has_key(v:val, "index_table")', [], 'v:val.index_table')
        let world.state_handlers   = filter(copy(handlers),   'has_key(v:val, "state")')
        let world.post_handlers    = filter(copy(handlers),   'has_key(v:val, "postprocess")')
        let world.filter_format    = tlib#list#Find(handlers, 'has_key(v:val, "filter_format")', '', 'v:val.filter_format')
        let world.return_agent     = tlib#list#Find(handlers, 'has_key(v:val, "return_agent")', '', 'v:val.return_agent')
        let world.help_extra       = tlib#list#Find(handlers, 'has_key(v:val, "help_extra")', '', 'v:val.help_extra')
        let world.resize           = tlib#list#Find(handlers, 'has_key(v:val, "resize")', '', 'v:val.resize')
        let world.show_empty       = tlib#list#Find(handlers, 'has_key(v:val, "show_empty")', 0, 'v:val.show_empty')
        let world.pick_last_item   = tlib#list#Find(handlers, 'has_key(v:val, "pick_last_item")', 
                    \ tlib#var#Get('tlib_pick_last_item', 'bg'), 'v:val.pick_last_item')
        let world.numeric_chars    = tlib#list#Find(handlers, 'has_key(v:val, "numeric_chars")', 
                    \ g:tlib#input#numeric_chars, 'v:val.numeric_chars')
        let world.key_handlers     = filter(copy(handlers), 'has_key(v:val, "key")')
        let filter                 = tlib#list#Find(handlers, 'has_key(v:val, "filter")', '', 'v:val.filter')
        if !empty(filter)
            " let world.initial_filter = [[''], [filter]]
            " let world.initial_filter = [[filter]]
            " TLogVAR world.initial_filter
            call world.SetInitialFilter(filter)
        endif
    endif
    return tlib#input#ListW(world)
endf


" A wrapper for |tlib#input#ListW()| that builds |tlib#World#New| from 
" dict.
function! tlib#input#ListD(dict) "{{{3
    return tlib#input#ListW(tlib#World#New(a:dict))
endf


" :def: function! tlib#input#ListW(world, ?command='')
" The second argument (command) is meant for internal use only.
" The same as |tlib#input#List| but the arguments are packed into world 
" (an instance of tlib#World as returned by |tlib#World#New|).
function! tlib#input#ListW(world, ...) "{{{3
    TVarArg 'cmd'
    " let time0 = str2float(reltimestr(reltime()))  " DBG
    " TLogVAR time0
    let world = a:world
    if world.pick_last_item >= 1 && stridx(world.type, 'e') == -1 && len(world.base) <= 1
        let rv = get(world.base, 0, world.rv)
        if stridx(world.type, 'm') != -1
            return [rv]
        else
            return rv
        endif
    endif
    call s:Init(world, cmd)
    " TLogVAR world.state, world.sticky, world.initial_index
    " let statusline  = &l:statusline
    " let laststatus  = &laststatus
    let lastsearch  = @/
    let scrolloff = &l:scrolloff
    let &l:scrolloff = 0
    let @/ = ''
    let dlist = []
    let post_keys = ''
    " let &laststatus = 2

    try
        while !empty(world.state) && world.state !~ '^exit' && (world.show_empty || !empty(world.base))
            let post_keys = ''
            " TLogDBG 'while'
            " TLogVAR world.state
            " let time01 = str2float(reltimestr(reltime()))  " DBG
            " TLogVAR time01, time01 - time0
            try
                call s:RunStateHandlers(world)

                " if exists('b:tlib_world_event')
                "     let event = b:tlib_world_event
                "     unlet! b:tlib_world_event
                "     if event == 'WinLeave'
                "         " let world.resume_state = world.state
                "         let world = tlib#agent#Suspend(world, world.rv)
                "         break
                "     endif
                " endif

                " let time02 = str2float(reltimestr(reltime()))  " DBG
                " TLogVAR time02, time02 - time0
                if world.state =~ '\<reset\>'
                    " TLogDBG 'reset'
                    " call world.Reset(world.state =~ '\<initial\>')
                    call world.Reset()
                    continue
                endif

                call s:SetOffset(world)

                " let time02 = str2float(reltimestr(reltime()))  " DBG
                " TLogVAR time02, time02 - time0
                " TLogDBG 1
                " TLogVAR world.state
                if world.state == 'scroll'
                    let world.prefidx = world.offset
                    let world.state = 'redisplay'
                endif

                if world.state =~ '\<sticky\>'
                    let world.sticky = 1
                endif

                " TLogVAR world.filter
                " TLogVAR world.sticky
                if world.state =~ '\<pick\>'
                    let world.rv = world.CurrentItem()
                    " TLogVAR world.rv
                    throw 'pick'
                elseif world.state =~ 'display'
                    if world.state =~ '^display'
                        " let time03 = str2float(reltimestr(reltime()))  " DBG
                        " TLogVAR time03, time03 - time0
                        if world.IsValidFilter()

                            " let time1 = str2float(reltimestr(reltime()))  " DBG
                            " TLogVAR time1, time1 - time0
                            call world.BuildTableList()
                            " let time2 = str2float(reltimestr(reltime()))  " DBG
                            " TLogVAR time2, time2 - time0
                            " TLogDBG 2
                            " TLogDBG len(world.table)
                            " TLogVAR world.table
                            " let world.list  = map(copy(world.table), 'world.GetBaseItem(v:val)')
                            " TLogDBG 3
                            let world.llen = len(world.list)
                            " TLogVAR world.index_table
                            if empty(world.index_table)
                                let dindex = range(1, world.llen)
                                let world.index_width = len(world.llen)
                            else
                                let dindex = world.index_table
                                let world.index_width = len(max(dindex))
                            endif
                            " let time3 = str2float(reltimestr(reltime()))  " DBG
                            " TLogVAR time3, time3 - time0
                            if world.llen == 0 && !world.show_empty
                                call world.ReduceFilter()
                                let world.offset = 1
                                " TLogDBG 'ReduceFilter'
                                continue
                            else
                                if world.llen == 1
                                    let world.last_item = world.list[0]
                                    if world.pick_last_item >= 2
                                        " echom 'Pick last item: '. world.list[0]
                                        let world.prefidx = '1'
                                        " TLogDBG 'pick last item'
                                        throw 'pick'
                                    endif
                                else
                                    let world.last_item = ''
                                endif
                            endif
                            " let time4 = str2float(reltimestr(reltime()))  " DBG
                            " TLogVAR time4, time4 - time0
                            " TLogDBG 4
                            " TLogVAR world.idx, world.llen, world.state
                            " TLogDBG world.FilterIsEmpty()
                            if world.state == 'display'
                                if world.idx == '' && world.llen < g:tlib#input#sortprefs_threshold && !world.FilterIsEmpty()
                                    call world.SetPrefIdx()
                                else
                                    let world.prefidx = world.idx == '' ? world.initial_index : world.idx
                                endif
                                if world.prefidx > world.llen
                                    let world.prefidx = world.llen
                                elseif world.prefidx < 1
                                    let world.prefidx = 1
                                endif
                            endif
                            " let time5 = str2float(reltimestr(reltime()))  " DBG
                            " TLogVAR time5, time5 - time0
                            " TLogVAR world.initial_index, world.prefidx
                            " TLogDBG 5
                            " TLogDBG len(world.list)
                            " TLogVAR world.list
                            let dlist = world.DisplayFormat(world.list)
                            " TLogVAR world.prefidx
                            " TLogDBG 6
                            " let time6 = str2float(reltimestr(reltime()))  " DBG
                            " TLogVAR time6, time6 - time0
                            if world.offset_horizontal > 0
                                call map(dlist, 'v:val[world.offset_horizontal:-1]')
                            endif
                            " let time7 = str2float(reltimestr(reltime()))  " DBG
                            " TLogVAR time7, time7 - time0
                            " TLogVAR dindex
                            let dlist = map(range(0, world.llen - 1), 'printf("%0'. world.index_width .'d", dindex[v:val]) .": ". dlist[v:val]')
                            " TLogVAR dlist
                            " let time8 = str2float(reltimestr(reltime()))  " DBG
                            " TLogVAR time8, time8 - time0

                        else

                            let dlist = ['Malformed filter']

                        endif
                    else
                        if world.prefidx == 0
                            let world.prefidx = 1
                        endif
                    endif
                    " TLogVAR world.idx, world.prefidx

                    " TLogDBG 7
                    " TLogVAR world.prefidx, world.offset
                    " TLogDBG (world.prefidx > world.offset + winheight(0) - 1)
                    " if world.prefidx > world.offset + winheight(0) - 1
                    "     let listtop = world.llen - winheight(0) + 1
                    "     let listoff = world.prefidx - winheight(0) + 1
                    "     let world.offset = min([listtop, listoff])
                    "     TLogVAR world.prefidx
                    "     TLogDBG len(list)
                    "     TLogDBG winheight(0)
                    "     TLogVAR listtop, listoff, world.offset
                    " elseif world.prefidx < world.offset
                    "     let world.offset = world.prefidx
                    " endif
                    " TLogDBG 8
                    if world.initial_display || !tlib#char#IsAvailable()
                        " TLogDBG len(dlist)
                        call world.DisplayList(world.Query(), dlist)
                        call world.FollowCursor()
                        let world.initial_display = 0
                        " TLogDBG 9
                    endif
                    if world.state =~ '\<hibernate\>'
                        let world.state = 'suspend'
                    else
                        let world.state = ''
                    endif
                else
                    " if world.state == 'scroll'
                    "     let world.prefidx = world.offset
                    " endif
                    call world.DisplayList()
                    if world.state == 'help' || world.state == 'printlines'
                        let world.state = 'display'
                    else
                        let world.state = ''
                        call world.FollowCursor()
                    endif
                endif
                " TAssert IsNotEmpty(world.scratch)
                let world.list_wnr = winnr()

                " TLogVAR world.state, world.next_state
                if !empty(world.next_state)
                    let world.state = world.next_state
                    let world.next_state = ''
                endif

                if world.state =~ '\<suspend\>'
                    let world = tlib#agent#SuspendToParentWindow(world, world.rv)
                    continue
                endif

                if world.state =~ '\<eval\>'
                    let query = matchstr(world.state, '\<eval\[\zs.\{-}\ze\]')
                    if empty(query)
                        let query = 'Waiting for input ... Press ESC to continue'
                    endif
                    if has('gui_win32')
                        let exec_cmd = input(query, '')
                        " TLogVAR exec_cmd
                        if exec_cmd == ''
                            let world.state = 'redisplay'
                        else
                            exec exec_cmd
                        endif
                    elseif has('gui_gtk') || has('gui_gtk2')
                        let c = s:GetModdedChar(world)
                        " TLogVAR c
                    endif
                else
                    " TLogVAR world.timeout
                    let c = s:GetModdedChar(world)
                    " TLogVAR c, has_key(world.key_map[world.key_mode],c)
                endif
                " TLogVAR c
                " TLogDBG string(sort(keys(world.key_map[world.key_mode])))

                " TLogVAR world.next_agent, world.next_eval
                if !empty(world.next_agent)
                    let nagent = world.next_agent
                    let world.next_agent = ''
                    let world = call(nagent, [world, world.GetSelectedItems(world.CurrentItem())])
                    call s:CheckAgentReturnValue(nagent, world)
                elseif !empty(world.next_eval)
                    let selected = world.GetSelectedItems(world.CurrentItem())
                    let neval = world.next_eval
                    let world.next_eval = ''
                    exec neval
                    call s:CheckAgentReturnValue(neval, world)
                elseif world.state != ''
                    " continue
                elseif has_key(world.key_map[world.key_mode], c)
                    let sr = @/
                    silent! let @/ = lastsearch
                    " TLogVAR c, world.key_map[world.key_mode][c]
                    " TLog "Agent: ". string(world.key_map[world.key_mode][c])
                    let handler = world.key_map[world.key_mode][c]
                    " TLogVAR handler
                    let world = call(handler.agent, [world, world.GetSelectedItems(world.CurrentItem())])
                    call s:CheckAgentReturnValue(c, world)
                    silent! let @/ = sr
                    " continue
                elseif c == 13
                    throw 'pick'
                elseif c == 27
                    " TLogVAR c, world.key_mode
                    if world.key_mode != 'default'
                        let world.key_mode = 'default'
                        let world.state = 'redisplay'
                    else
                        let world.state = 'exit empty'
                    endif
                elseif c == "\<LeftMouse>"
                    if v:mouse_win == world.list_wnr
                        let world.prefidx = world.GetLineIdx(v:mouse_lnum)
                        " let world.offset  = world.prefidx
                        if empty(world.prefidx)
                            " call feedkeys(c, 't')
                            let c = s:GetModdedChar(world)
                            let world.state = 'help'
                            continue
                        endif
                        throw 'pick'
                    else
                        let post_keys = v:mouse_lnum .'gg'. v:mouse_col .'|'. c
                        if world.allow_suspend
                            let world = tlib#agent#SuspendToParentWindow(world, world.rv)
                        else
                            let world.state = 'exit empty'
                        endif
                    endif
                elseif c == "\<RightMouse>"
                    if v:mouse_win == world.list_wnr
                        call s:BuildMenu(world)
                        let world.state = 'redisplay'
                        if s:PopupmenuExists() == 1
                            " if v:mouse_lnum != line('.')
                            " endif
                            let world.prefidx = world.GetLineIdx(v:mouse_lnum)
                            let world.next_state = 'eval[Waiting for popup menu ... Press ESC to continue]'
                            call world.DisplayList()
                            if line('w$') - v:mouse_lnum < 6
                                popup ]TLibInputListPopupMenu
                            else
                                popup! ]TLibInputListPopupMenu
                            endif
                        endif
                    else
                        let post_keys = v:mouse_lnum .'gg'. v:mouse_col .'|'. c
                        if world.allow_suspend
                            let world = tlib#agent#SuspendToParentWindow(world, world.rv)
                        else
                            let world.state = 'exit empty'
                        endif
                    endif
                    " TLogVAR world.prefidx, world.state
                elseif has_key(world.key_map[world.key_mode], 'unknown_key')
                    let agent = world.key_map[world.key_mode].unknown_key.agent
                    let world = call(agent, [world, c])
                    call s:CheckAgentReturnValue(agent, world)
                elseif c >= 32
                    let world.state = 'display'
                    let numbase = get(world.numeric_chars, c, -99999)
                    " TLogVAR numbase, world.numeric_chars, c
                    if numbase != -99999
                        let world.idx .= (c - numbase)
                        if len(world.idx) == world.index_width
                            let world.prefidx = world.idx
                            " TLogVAR world.prefidx
                            throw 'pick'
                        endif
                    else
                        let world.idx = ''
                        " TLogVAR world.filter
                        if world.llen > g:tlib#input#livesearch_threshold
                            let pattern = input('Filter: ', world.CleanFilter(world.filter[0][0]) . nr2char(c))
                            if empty(pattern)
                                let world.state = 'exit empty'
                            else
                                call world.SetFrontFilter(pattern)
                                echo
                            endif
                        elseif c == 124
                            call insert(world.filter[0], [])
                        else
                            call world.PushFrontFilter(c)
                        endif
                        " continue
                        if c == 45 && world.filter[0][0] == '-'
                            let world.state = 'redisplay'
                        end
                    endif
                else
                    let world.state = 'redisplay'
                    " let world.state = 'continue'
                endif

            catch /^pick$/
                call world.ClearAllMarks()
                call world.MarkCurrent(world.prefidx)
                let world.state = ''
                " TLogDBG 'Pick item #'. world.prefidx

            finally
                " TLogDBG 'finally 1'
                if world.state =~ '\<suspend\>'
                    " if !world.allow_suspend
                    "     echom "Cannot be suspended"
                    "     let world.state = 'redisplay'
                    " endif
                elseif !empty(world.list) && !empty(world.base)
                    " TLogVAR world.list
                    if empty(world.state)
                        " TLogVAR world.state
                        let world.rv = world.CurrentItem()
                    endif
                    " TLog "postprocess"
                    for handler in world.post_handlers
                        let state = get(handler, 'postprocess', '')
                        " TLogVAR handler
                        " TLogVAR state
                        " TLogVAR world.state
                        if state == world.state
                            let agent = handler.agent
                            let [world, world.rv] = call(agent, [world, world.rv])
                            " TLogVAR world.state, world.rv
                            call s:CheckAgentReturnValue(agent, world)
                        endif
                    endfor
                endif
                " TLogDBG 'state0='. world.state
            endtry
            " TLogDBG 'state1='. world.state
        endwh

        " TLogVAR world.state
        " TLogDBG string(tlib#win#List())
        " TLogDBG 'exit while loop'
        " TLogVAR world.list
        " TLogVAR world.sel_idx
        " TLogVAR world.idx
        " TLogVAR world.prefidx
        " TLogVAR world.rv
        " TLogVAR world.type, world.state, world.return_agent, world.index_table, world.rv
        if world.state =~ '\<\(empty\|escape\)\>'
            let world.sticky = 0
        endif
        if world.state =~ '\<suspend\>'
            " TLogDBG 'return suspended'
            " TLogVAR world.prefidx
            " exec world.prefidx
            return
        elseif world.state =~ '\<empty\>'
            " TLog "empty"
            " TLogDBG 'return empty'
            " TLogVAR world.type
            if stridx(world.type, 'm') != -1
                return []
            elseif stridx(world.type, 'i') != -1
                return 0
            else
                return ''
            endif
        elseif !empty(world.return_agent)
            " TLog "return_agent"
            " TLogDBG 'return agent'
            " TLogVAR world.return_agent
            call world.CloseScratch()
            " TLogDBG "return_agent ". string(tlib#win#List())
            " TAssert IsNotEmpty(world.scratch)
            return call(world.return_agent, [world, world.GetSelectedItems(world.rv)])
        elseif stridx(world.type, 'w') != -1
            " TLog "return_world"
            " TLogDBG 'return world'
            return world
        elseif stridx(world.type, 'm') != -1
            " TLog "return_multi"
            " TLogDBG 'return multi'
            return world.GetSelectedItems(world.rv)
        elseif stridx(world.type, 'i') != -1
            " TLog "return_index"
            " TLogDBG 'return index'
            if empty(world.index_table)
                return world.rv
            else
                return world.index_table[world.rv - 1]
            endif
        else
            " TLog "return_else"
            " TLogDBG 'return normal'
            return world.rv
        endif

    finally
        call world.Leave()

        " TLogVAR statusline
        " let &l:statusline = statusline
        " let &laststatus = laststatus
        silent! let @/  = lastsearch
        let &l:scrolloff = scrolloff
        if s:PopupmenuExists() == 1
            silent! aunmenu ]TLibInputListPopupMenu
        endif

        " TLogDBG 'finally 2'
        " TLogDBG string(world.Methods())
        " TLogVAR world.state
        " TLogDBG string(tlib#win#List())
        if world.state !~ '\<suspend\>'
            " redraw
            " TLogVAR world.sticky, bufnr("%")
            if world.sticky
                " TLogDBG "sticky"
                " TLogVAR world.bufnr
                " TLogDBG bufwinnr(world.bufnr)
                if world.scratch_split > 0
                    if bufwinnr(world.bufnr) == -1
                        " TLogDBG "UseScratch"
                        call world.UseScratch()
                    endif
                    let world = tlib#agent#SuspendToParentWindow(world, world.GetSelectedItems(world.rv))
                endif
            else
                " TLogDBG "non sticky"
                " TLogVAR world.state, world.win_wnr, world.bufnr
                if world.CloseScratch()
                    " TLogVAR world.winview
                    call tlib#win#SetLayout(world.winview)
                endif
            endif
        endif
        " for i in range(0,5)
        "     call getchar(0)
        " endfor
        echo
        redraw!
        if !empty(post_keys)
            " TLogVAR post_keys
            call feedkeys(post_keys)
        endif
    endtry
endf


function! s:GetModdedChar(world) "{{{3
    let [char, mode] = tlib#char#Get(a:world.timeout, a:world.timeout_resolution, 1)
    if char !~ '\D' && char > 0 && mode != 0
        return printf("<%s-%s>", mode, char)
    else
        return char
    endif
endf


function! s:Init(world, cmd) "{{{3
    " TLogVAR a:cmd
    let a:world.initial_display = 1
    if a:cmd =~ '\<sticky\>'
        let a:world.sticky = 1
    endif
    if a:cmd =~ '^resume'
        call a:world.UseInputListScratch()
        let a:world.initial_index = line('.')
        if a:cmd =~ '\<pick\>'
            let a:world.state = 'pick'
            let a:world.prefidx = a:world.initial_index
        else
            call a:world.Retrieve(1)
        endif
        " if !empty(a:world.resume_state)
        "     let a:world.state = a:world.resume_state
        " endif
    elseif !a:world.initialized
        " TLogVAR a:world.initialized, a:world.win_wnr, a:world.bufnr
        let a:world.filetype = &filetype
        let a:world.fileencoding = &fileencoding
        call a:world.SetMatchMode(tlib#var#Get('tlib#input#filter_mode', 'wb'))
        call a:world.Initialize()
        if !has_key(a:world, 'key_mode')
            let a:world.key_mode = 'default'
        endif
        " TLogVAR has_key(a:world,'key_map')
        if has_key(a:world, 'key_map')
            " TLogVAR has_key(a:world.key_map,a:world.key_mode)
            if has_key(a:world.key_map, a:world.key_mode)
                let a:world.key_map[a:world.key_mode] = extend(
                            \ a:world.key_map[a:world.key_mode],
                            \ copy(g:tlib#input#keyagents_InputList_s),
                            \ 'keep')
            else
                let a:world.key_map[a:world.key_mode] = copy(g:tlib#input#keyagents_InputList_s)
            endif
        else
            let a:world.key_map = {
                        \ a:world.key_mode : copy(g:tlib#input#keyagents_InputList_s)
                        \ }
        endif
        " TLogVAR a:world.type
        if stridx(a:world.type, 'm') != -1
            call extend(a:world.key_map[a:world.key_mode], g:tlib#input#keyagents_InputList_m, 'force')
        endif
        for key_mode in keys(a:world.key_map)
            let a:world.key_map[key_mode] = map(a:world.key_map[key_mode], 'type(v:val) == 4 ? v:val : {"agent": v:val}')
        endfor
        if type(a:world.key_handlers) == 3
            call s:ExtendKeyMap(a:world, a:world.key_mode, a:world.key_handlers)
        elseif type(a:world.key_handlers) == 4
            for [world_key_mode, world_key_handlers] in items(a:world.key_handlers)
                call s:ExtendKeyMap(a:world, world_key_mode, world_key_handlers)
            endfor
        else
            throw "tlib#input#ListW: key_handlers must be either a list or a dictionary"
        endif
        if !empty(a:cmd)
            let a:world.state .= ' '. a:cmd
        endif
    endif
    " TLogVAR a:world.state, a:world.sticky
endf


function! s:ExtendKeyMap(world, key_mode, key_handlers) "{{{3
    for handler in a:key_handlers
        let k = get(handler, 'key', '')
        if !empty(k)
            let a:world.key_map[a:key_mode][k] = handler
        endif
    endfor
endf


function s:PopupmenuExists()
    if !g:tlib#input#use_popup
                \ || exists(':popup') != 2
                \ || !(has('gui_win32') || has('gui_gtk') || has('gui_gtk2'))
                " \ || !has('gui_win32')
        let rv = -1
    else
        try
            let rv = 1
            silent amenu ]TLibInputListPopupMenu
        catch
            let rv = 0
        endtry
    endif
    " TLogVAR rv
    return rv
endf


function! s:BuildMenu(world) "{{{3
    if g:tlib#input#use_popup && s:PopupmenuExists() == 0
        call s:BuildItem('Pick\ selected\ item', {'key_name': '<cr>', 'eval': 'let world.state = "pick"'})
        call s:BuildItem('Cancel', {'key_name': '<esc>', 'agent': 'tlib#agent#Exit'})
        call s:BuildItem('Select', {'key_name': '#', 'agent': 'tlib#agent#Select'})
        call s:BuildItem('Select\ all', {'key_name': '<c-a>', 'agent': 'tlib#agent#SelectAll'})
        call s:BuildItem('Reset\ list', {'key_name': '<c-r>', 'agent': 'tlib#agent#Reset'})
        call s:BuildItem('-StandardEntries-', {'key': ":", 'eval': 'let world.state = "redisplay"'})
        for [key_mode, key_handlers] in items(a:world.key_map)
            let keys = sort(keys(key_handlers))
            let mitems = {}
            for key in keys
                let handler = key_handlers[key]
                let k = get(handler, 'key', '')
                if !empty(k) && has_key(handler, 'help') && !empty(handler.help)
                    if empty(key_mode) || key_mode == 'default'
                        let mname = ''
                    else
                        let mname = escape(key_mode, ' .\') .'.'
                    endif
                    if has_key(handler, 'submenu')
                        let submenu = escape(handler.submenu, ' .\')
                    else
                        let submenu = '~'
                    endif
                    for mfield in ['menu', 'help', 'key_name', 'agent']
                        if has_key(handler, mfield)
                            let mname .= escape(handler[mfield], ' .\')
                            break
                        endif
                    endfor
                    if !has_key(mitems, submenu)
                        let mitems[submenu] = {}
                    endif
                    let mitems[submenu][mname] = handler
                endif
            endfor
            for msubname in sort(keys(mitems))
                let msubitems = mitems[msubname]
                if msubname == '~'
                    let msubmname = ''
                else
                    let msubmname = msubname .'.'
                endif
                for mname in sort(keys(msubitems))
                    let msname = msubmname . mname
                    let handler = msubitems[mname]
                    call s:BuildItem(msname, handler)
                    " if has_key(handler, 'agent')
                    "     call s:BuildItem(msname, {'agent': handler.agent})
                    " else
                    "     call s:BuildItem(msname, {'key': handler.key_name})
                    " endif
                endfor
            endfor
        endfor
    endif
endf


function! s:BuildItem(menu, def) "{{{3
    if has('gui_win32')
        let key_mode = 'c'
    elseif has('gui_gtk') || has('gui_gtk2')
        let key_mode = 'raw'
    endif
    for k in ['agent', 'eval', 'key_name', 'key']
        if has('gui_win32')
        elseif has('gui_gtk') || has('gui_gtk')
            if k == 'agent' || k == 'eval'
                continue
            endif
        endif
        try 
            if has_key(a:def, k)
                let v = a:def[k]
                if k == 'key'
                    if key_mode == 'c'
                        " echom 'DBG amenu' (']TLibInputListPopupMenu.'. a:menu) ':let c = "'. v .'"<cr>'
                        exec 'amenu' (']TLibInputListPopupMenu.'. a:menu) ':let c = "'. v .'"<cr>'
                    else
                        " echom 'DBG amenu' (']TLibInputListPopupMenu.'. a:menu) v
                        exec 'amenu' (']TLibInputListPopupMenu.'. a:menu) v
                    endif
                elseif k == 'key_name'
                    if key_mode == 'c'
                        " echom 'DBG amenu' (']TLibInputListPopupMenu.'. a:menu) ':let c = "\'. v .'"<cr>'
                        exec 'amenu' (']TLibInputListPopupMenu.'. a:menu) ':let c = "\'. v .'"<cr>'
                    else
                        let key = v
                        " echom 'DBG amenu' (']TLibInputListPopupMenu.'. a:menu) key
                        exec 'amenu' (']TLibInputListPopupMenu.'. a:menu) key
                    endif
                elseif k == 'agent'
                    " echom 'DBG amenu' (']TLibInputListPopupMenu.'. a:menu) ':let world.next_agent ='. string(v) .'<cr>'
                    exec 'amenu' (']TLibInputListPopupMenu.'. a:menu) ':let world.next_agent ='. string(v) .'<cr>'
                elseif k == 'eval'
                    " echom 'DBG amenu' (']TLibInputListPopupMenu.'. a:menu) ':let world.next_eval ='. string(v) .'<cr>'
                    exec 'amenu' (']TLibInputListPopupMenu.'. a:menu) ':let world.next_eval ='. string(v) .'<cr>'
                endif
                return
            endif
        catch
        endtry
    endfor
endf


function! s:RunStateHandlers(world) "{{{3
    " Provide the variable "world" in the environment of an "exec" 
    " handler (ea).
    let world = a:world
    for handler in a:world.state_handlers
        let eh = get(handler, 'state', '')
        if !empty(eh) && a:world.state =~ eh
            let ea = get(handler, 'exec', '')
            if !empty(ea)
                exec ea
            else
                let agent = get(handler, 'agent', '')
                let a:world = call(agent, [a:world, a:world.GetSelectedItems(a:world.CurrentItem())])
                call s:CheckAgentReturnValue(agent, a:world)
            endif
        endif
    endfor
endf


function! s:CheckAgentReturnValue(name, value) "{{{3
    if type(a:value) != 4 && !has_key(a:value, 'state')
        echoerr 'Malformed agent: '. a:name
    endif
    return a:value
endf


function! s:SetOffset(world) "{{{3
    let llenw = len(a:world.base) - winheight(0) + 1
    if a:world.offset > llenw
        let a:world.offset = llenw
    endif
    if a:world.offset < 1
        let a:world.offset = 1
    endif
endf


" Functions related to tlib#input#EditList(type, ...) "{{{2

" :def: function! tlib#input#EditList(query, list, ?timeout=0)
" Edit a list.
"
" EXAMPLES: >
"   echo tlib#input#EditList('Edit:', [100,200,300])
function! tlib#input#EditList(query, list, ...) "{{{3
    let handlers = a:0 >= 1 && !empty(a:1) ? a:1 : g:tlib#input#handlers_EditList
    let default  = a:0 >= 2 ? a:2 : []
    let timeout  = a:0 >= 3 ? a:3 : 0
    " TLogVAR handlers
    let rv = tlib#input#List('me', a:query, copy(a:list), handlers, default, timeout)
    " TLogVAR rv
    if empty(rv)
        return a:list
    else
        let [success, list] = rv
        return success ? list : a:list
    endif
endf


function! tlib#input#Resume(name, pick, bufnr) "{{{3
    " TLogVAR a:name, a:pick
    echo
    if bufnr('%') != a:bufnr
        if g:tlib#debug
            echohl WarningMsg
            echom "tlib#input#Resume: Internal error: Not in scratch buffer:" bufname('%')
            echohl NONE
        endif
        let br = tlib#buffer#Set(a:bufnr)
    endif
    if !exists('b:tlib_'. a:name)
        if g:tlib#debug
            echohl WarningMsg
            echom "tlib#input#Resume: Internal error: b:tlib_". a:name ." does not exist:" bufname('%')
            echohl NONE
            redir => varss
            silent let b:
            redir END
            let vars = split(varss, '\n')
            call filter(vars, 'v:val =~ "^b:tlib_"')
            echom "DEBUG tlib#input#Resume" string(vars)
        endif
    else
        call tlib#autocmdgroup#Init()
        autocmd! TLib BufEnter <buffer>
        if b:tlib_{a:name}.state =~ '\<suspend\>'
            let b:tlib_{a:name}.state = 'redisplay'
        else
            let b:tlib_{a:name}.state .= ' redisplay'
        endif
        " call tlib#input#List('resume '. a:name)
        let cmd = 'resume '. a:name
        if a:pick >= 1
            let cmd .= ' pick'
            if a:pick >= 2
                let cmd .= ' sticky'
            end
        endif
        call tlib#input#ListW(b:tlib_{a:name}, cmd)
    endif
endf


" :def: function! tlib#input#CommandSelect(command, ?keyargs={})
" Take a command, view the output, and let the user select an item from 
" its output.
"
" EXAMPLE: >
"     command! TMarks exec 'norm! `'. matchstr(tlib#input#CommandSelect('marks'), '^ \+\zs.')
"     command! TAbbrevs exec 'norm i'. matchstr(tlib#input#CommandSelect('abbrev'), '^\S\+\s\+\zs\S\+')
function! tlib#input#CommandSelect(command, ...) "{{{3
    TVarArg ['args', {}]
    if has_key(args, 'retrieve')
        let list = call(args.retrieve)
    elseif has_key(args, 'list')
        let list = args.list
    else
        let list = tlib#cmd#OutputAsList(a:command)
    endif
    if has_key(args, 'filter')
        call map(list, args.filter)
    endif
    let type     = has_key(args, 'type') ? args.type : 's'
    let handlers = has_key(args, 'handlers') ? args.handlers : []
    let rv = tlib#input#List(type, 'Select', list, handlers)
    if !empty(rv)
        if has_key(args, 'process')
            let rv = call(args.process, [rv])
        endif
    endif
    return rv
endf


" :def: function! tlib#input#Edit(name, value, callback, ?cb_args=[])
"
" Edit a value (asynchronously) in a scratch buffer. Use name for 
" identification. Call callback when done (or on cancel).
" In the scratch buffer:
" Press <c-s> or <c-w><cr> to enter the new value, <c-w>c to cancel 
" editing.
" EXAMPLES: >
"   fun! FooContinue(success, text)
"       if a:success
"           let b:var = a:text
"       endif
"   endf
"   call tlib#input#Edit('foo', b:var, 'FooContinue')
function! tlib#input#Edit(name, value, callback, ...) "{{{3
    " TLogVAR a:value
    TVarArg ['args', []]
    let sargs = {'scratch': '__EDIT__'. a:name .'__', 'win_wnr': winnr()}
    let scr = tlib#scratch#UseScratch(sargs)

    " :nodoc:
    map <buffer> <c-w>c :call <SID>EditCallback(0)<cr>
    " :nodoc:
    imap <buffer> <c-w>c <c-o>call <SID>EditCallback(0)<cr>
    " :nodoc:
    map <buffer> <c-s> :call <SID>EditCallback(1)<cr>
    " :nodoc:
    imap <buffer> <c-s> <c-o>call <SID>EditCallback(1)<cr>
    " :nodoc:
    map <buffer> <c-w><cr> :call <SID>EditCallback(1)<cr>
    " :nodoc:
    imap <buffer> <c-w><cr> <c-o>call <SID>EditCallback(1)<cr>
    
    call tlib#normal#WithRegister('gg"tdG', 't')
    call append(1, split(a:value, "\<c-j>", 1))
    " let hrm = 'DON''T DELETE THIS HEADER'
    " let hr3 = repeat('"', (tlib#win#Width(0) - len(hrm)) / 2)
    let s:horizontal_line = repeat('`', tlib#win#Width(0))
    " hr3.hrm.hr3
    let hd  = ['Keys: <c-s>, <c-w><cr> ... save/accept; <c-w>c ... cancel', s:horizontal_line]
    call append(1, hd)
    call tlib#normal#WithRegister('gg"tdd', 't')
    syntax match TlibEditComment /^\%1l.*/
    syntax match TlibEditComment /^```.*/
    hi link TlibEditComment Comment
    exec len(hd) + 1
    if type(a:callback) == 4
        let b:tlib_scratch_edit_callback = get(a:callback, 'submit', '')
        call call(get(a:callback, 'init', ''), [])
    else
        let b:tlib_scratch_edit_callback = a:callback
    endif
    let b:tlib_scratch_edit_args     = args
    let b:tlib_scratch_edit_scratch  = sargs
    " exec 'autocmd BufDelete,BufHidden,BufUnload <buffer> call s:EditCallback('. string(a:name) .')'
    " echohl MoreMsg
    " echom 'Press <c-s> to enter, <c-w>c to cancel editing.'
    " echohl NONE
endf


function! s:EditCallback(...) "{{{3
    TVarArg ['ok', -1]
    " , ['bufnr', -1]
    " autocmd! BufDelete,BufHidden,BufUnload <buffer>
    if ok == -1
        let ok = confirm('Use value')
    endif
    let start = getline(2) == s:horizontal_line ? 3 : 1
    let text = ok ? join(getline(start, '$'), "\n") : ''
    let cb   = b:tlib_scratch_edit_callback
    let args = b:tlib_scratch_edit_args
    let sargs = b:tlib_scratch_edit_scratch
    " TLogVAR cb, args, sargs
    call tlib#scratch#CloseScratch(b:tlib_scratch_edit_scratch)
    call tlib#win#Set(sargs.win_wnr)
    call call(cb, args + [ok, text])
endf


function! tlib#input#Dialog(text, options, default) "{{{3
    if has('dialog_con') || has('dialog_gui')
        let opts = join(map(a:options, '"&". v:val'), "\n")
        let val = confirm(a:text, opts)
        if val
            let yn = a:options[val - 1]
        else
            let yn = a:default
        endif
    else
        let oi = index(a:options, a:default)
        if oi == -1
            let opts = printf("(%s|%s)", join(a:options, '/'), a:default)
        else
            let options = copy(a:options)
            let options[oi] = toupper(options[oi])
            let opts = printf("(%s)", join(a:options, '/'))
        endif
        let yn = inputdialog(a:text .' '. opts)
    endif
    return yn
endf

autoload/tlib/number.vim	[[[1
30
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    14


function! tlib#number#ConvertBase(num, base, ...) "{{{3
    let rtype = a:0 >= 1 ? a:1 : 'string'
    " TLogVAR a:num, a:base, rtype
    let rv = []
    let num = 0.0 + a:num
    while floor(num) > 0.0
        let div = floor(num / a:base)
        let num1 = float2nr(num - a:base * div)
        if a:base <= 10
            call insert(rv, num1)
        elseif a:base == 16
            let char = "0123456789ABCDEF"[num1]
            call insert(rv, char)
        endif
        let num = num / a:base
    endwh
    " TLogVAR rv
    if rtype == 'list'
        return rv
    else
        return join(rv, '')
    endif
endf


autoload/tlib/file.vim	[[[1
164
" file.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2013-09-25.
" @Revision:    0.0.142

if &cp || exists("loaded_tlib_file_autoload")
    finish
endif
let loaded_tlib_file_autoload = 1


""" File related {{{1
" For the following functions please see ../../test/tlib.vim for examples.


" EXAMPLES: >
"   tlib#file#Split('foo/bar/filename.txt')
"   => ['foo', 'bar', 'filename.txt']
function! tlib#file#Split(filename) "{{{3
    let prefix = matchstr(a:filename, '^\(\w\+:\)\?/\+')
    " TLogVAR prefix
    if !empty(prefix)
        let filename = a:filename[len(prefix) : -1]
    else
        let filename = a:filename
    endif
    let rv = split(filename, '[\/]')
    " let rv = split(filename, '[\/]', 1)
    if !empty(prefix)
        call insert(rv, prefix[0:-2])
    endif
    return rv
endf


" :display: tlib#file#Join(filename_parts, ?strip_slashes=1)
" EXAMPLES: >
"   tlib#file#Join(['foo', 'bar', 'filename.txt'])
"   => 'foo/bar/filename.txt'
function! tlib#file#Join(filename_parts, ...) "{{{3
    TVarArg ['strip_slashes', 1]
    " TLogVAR a:filename_parts, strip_slashes
    if strip_slashes
        " let rx    = tlib#rx#Escape(g:tlib#dir#sep) .'$'
        let rx    = '[/\\]\+$'
        let parts = map(copy(a:filename_parts), 'substitute(v:val, rx, "", "")')
        " TLogVAR parts
        return join(parts, g:tlib#dir#sep)
    else
        return join(a:filename_parts, g:tlib#dir#sep)
    endif
endf


" EXAMPLES: >
"   tlib#file#Relative('foo/bar/filename.txt', 'foo')
"   => 'bar/filename.txt'
function! tlib#file#Relative(filename, basedir) "{{{3
    " TLogVAR a:filename, a:basedir
    " TLogDBG getcwd()
    " TLogDBG expand('%:p')
    let b0 = tlib#file#Absolute(a:basedir)
    let b  = tlib#file#Split(b0)
    " TLogVAR b
    let f0 = tlib#file#Absolute(a:filename)
    let fn = fnamemodify(f0, ':t')
    let fd = fnamemodify(f0, ':h')
    let f  = tlib#file#Split(fd)
    " TLogVAR f0, fn, fd, f
    if f[0] != b[0]
        let rv = f0
    else
        while !empty(f) && !empty(b)
            if f[0] != b[0]
                break
            endif
            call remove(f, 0)
            call remove(b, 0)
        endwh
        " TLogVAR f, b
        let rv = tlib#file#Join(repeat(['..'], len(b)) + f + [fn])
    endif
    " TLogVAR rv
    return rv
endf


function! tlib#file#Absolute(filename, ...) "{{{3
    if filereadable(a:filename)
        let filename = fnamemodify(a:filename, ':p')
    elseif a:filename =~ '^\(/\|[^\/]\+:\)'
        let filename = a:filename
    else
        let cwd = a:0 >= 1 ? a:1 : getcwd()
        let filename = tlib#file#Join([cwd, a:filename])
    endif
    let filename = substitute(filename, '\(^\|[\/]\)\zs\.[\/]', '', 'g')
    let filename = substitute(filename, '[\/]\zs[^\/]\+[\/]\.\.[\/]', '', 'g')
    return filename
endf


function! s:SetScrollBind(world) "{{{3
    let sb = get(a:world, 'scrollbind', &scrollbind)
    if sb != &scrollbind
        let &scrollbind = sb
    endif
endf


" :def: function! tlib#file#With(fcmd, bcmd, files, ?world={})
function! tlib#file#With(fcmd, bcmd, files, ...) "{{{3
    " TLogVAR a:fcmd, a:bcmd, a:files
    exec tlib#arg#Let([['world', {}]])
    call tlib#autocmdgroup#Init()
    augroup TLibFileRead
        autocmd!
    augroup END
    for f in a:files
        let bn = bufnr('^'.f.'$')
        " TLogVAR f, bn
        let bufloaded = bufloaded(bn)
        let ok = 0
        let s:bufread = ""
        if bn != -1 && buflisted(bn)
            if !empty(a:bcmd)
                " TLogDBG a:bcmd .' '. bn
                exec a:bcmd .' '. bn
                let ok = 1
                call s:SetScrollBind(world)
            endif
        else
            if filereadable(f)
                if !empty(a:fcmd)
                    " TLogDBG a:fcmd .' '. tlib#arg#Ex(f)
                    exec 'autocmd TLibFileRead BufRead' escape(f, '\ ') 'let s:bufread=expand("<afile>:p")'
                    try 
                        exec a:fcmd .' '. tlib#arg#Ex(f)
                    finally
                        exec 'autocmd! TLibFileRead BufRead'
                    endtry
                    let ok = 1
                    call s:SetScrollBind(world)
                endif
            else
                echohl error
                echom 'File not readable: '. f
                echohl NONE
            endif
        endif
        " TLogVAR ok, bufloaded, &filetype
        if empty(s:bufread) && ok && !bufloaded && empty(&filetype)
            doautocmd BufRead
        endif
    endfor
    augroup! TLibFileRead
    unlet! s:bufread
    " TLogDBG "done"
endf


autoload/tlib/paragraph.vim	[[[1
97
" paragraph.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2009-10-26.
" @Last Change: 2011-04-03.
" @Revision:    62

let s:save_cpo = &cpo
set cpo&vim


" Return an object describing a |paragraph|.
function! tlib#paragraph#GetMetric() "{{{3
    let sp = {'text_start': line("'{") + 1}
    if line("'}") == line("$")
        let sp.last = 1
        let sp.text_end = line("'}")
        if line("'{") == 1
            let sp.ws_start = 0
            let sp.ws_end = 0
            let sp.top = sp.text_start
            let sp.bottom = sp.text_end
        else
            let sp.ws_start = prevnonblank(line("'{")) + 1
            let sp.ws_end = line("'{")
            let sp.top = sp.ws_start
            let sp.bottom = sp.text_end
        endif
    else
        let sp.last = 0
        let sp.text_end = line("'}") - 1
        let sp.ws_start = line("'}")
        for i in range(line("'}"), line('$'))
            if getline(i) =~ '\w'
                let sp.ws_end = i - 1
                break
            elseif i == line("$")
                let sp.ws_end = i
            endif
        endfor
        let sp.top = sp.text_start
        let sp.bottom = sp.ws_end
    endif
    return sp
endf


" This function can be used with the tinymode plugin to move around 
" paragraphs.
"
" Example configuration: >
" 
"   call tinymode#EnterMap("para_move", "gp")
"   call tinymode#ModeMsg("para_move", "Move paragraph: j/k")
"   call tinymode#Map("para_move", "j", "silent call tlib#paragraph#Move('Down', '[N]')")
"   call tinymode#Map("para_move", "k", "silent call tlib#paragraph#Move('Up', '[N]')")
"   call tinymode#ModeArg("para_move", "owncount", 1)
function! tlib#paragraph#Move(direction, count)
    " TLogVAR a:direction, a:count
    let mycount = empty(a:count) ? 1 : a:count
    for i in range(1, mycount)
        let para = tlib#paragraph#GetMetric()
        " TLogVAR para
        let text = getline(para.text_start, para.text_end)
        let ws = getline(para.ws_start, para.ws_end)
        " TLogVAR text, ws
        exec para.top .','. para.bottom .'delete'
        if a:direction == "Down"
            let other = tlib#paragraph#GetMetric()
            let target = other.bottom + 1
            if other.last
                let lines = ws + text
                let pos = target + len(ws)
            else
                let lines = text + ws
                let pos = target
            endif
        elseif a:direction == "Up"
            if !para.last
                norm! {
            endif
            let other = tlib#paragraph#GetMetric()
            let target = other.text_start
            let lines = text + ws
            let pos = target
        endif
        " TLogVAR other, target
        " TLogVAR lines
        call append(target - 1, lines)
        exec pos
    endfor
endf


let &cpo = s:save_cpo
unlet s:save_cpo
autoload/tlib/World.vim	[[[1
1368
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    1389

" :filedoc:
" A prototype used by |tlib#input#List|.
" Inherits from |tlib#Object#New|.


" Size of the input list window (in percent) from the main size (of &lines).
" See |tlib#input#List()|.
TLet g:tlib_inputlist_pct = 50

" Size of filename columns when listing filenames.
" See |tlib#input#List()|.
TLet g:tlib_inputlist_width_filename = '&co / 3'
" TLet g:tlib_inputlist_width_filename = 25

" If true, |tlib#input#List()| will show some indicators about the 
" status of a filename (e.g. buflisted(), bufloaded() etc.).
" This is disabled by default because vim checks also for the file on 
" disk when doing this.
TLet g:tlib_inputlist_filename_indicators = 0

" If not null, display only a short info about the filter.
TLet g:tlib_inputlist_shortmessage = 0



" Known keys & values:
"   scratch_split ... See |tlib#scratch#UseScratch()|
let s:prototype = tlib#Object#New({
            \ '_class': 'World',
            \ 'name': 'world',
            \ 'allow_suspend': 1,
            \ 'base': [], 
            \ 'bufnr': -1,
            \ 'buffer_local': 1,
            \ 'cache_var': '',
            \ 'display_format': '',
            \ 'fileencoding': &fileencoding,
            \ 'fmt_display': {},
            \ 'fmt_filter': {},
            \ 'fmt_options': {},
            \ 'filetype': '',
            \ 'filter': [['']],
            \ 'filter_format': '',
            \ 'filter_options': '',
            \ 'follow_cursor': '',
            \ 'has_menu': 0,
            \ 'help_extra': [],
            \ 'index_table': [],
            \ 'initial_filter': [['']],
            \ 'initial_index': 1,
            \ 'initial_display': 1,
            \ 'initialized': 0,
            \ 'key_handlers': [],
            \ 'list': [],
            \ 'matcher': {},
            \ 'next_agent': '',
            \ 'next_eval': '',
            \ 'next_state': '',
            \ 'numeric_chars': g:tlib#input#numeric_chars,
            \ 'offset': 1,
            \ 'offset_horizontal': 0,
            \ 'on_leave': [],
            \ 'pick_last_item': tlib#var#Get('tlib#input#pick_last_item', 'bg'),
            \ 'post_handlers': [],
            \ 'query': '',
            \ 'resize': 0,
            \ 'resize_vertical': 0,
            \ 'restore_from_cache': [],
            \ 'filtered_items': [],
            \ 'resume_state': '', 
            \ 'retrieve_eval': '',
            \ 'return_agent': '',
            \ 'rv': '',
            \ 'scratch': '__InputList__',
            \ 'scratch_filetype': 'tlibInputList',
            \ 'scratch_hidden': g:tlib#scratch#hidden,
            \ 'scratch_vertical': 0,
            \ 'scratch_split': 1,
            \ 'sel_idx': [],
            \ 'show_empty': 0,
            \ 'state': 'display', 
            \ 'state_handlers': [],
            \ 'sticky': 0,
            \ 'temp_lines': [],
            \ 'temp_prompt': [],
            \ 'timeout': 0,
            \ 'timeout_resolution': 2,
            \ 'tabpagenr': -1,
            \ 'type': '', 
            \ 'win_wnr': -1,
            \ 'win_height': -1,
            \ 'win_width': -1,
            \ 'win_pct': 25,
            \ })
            " \ 'handlers': [],
            " \ 'filter_options': '\c',

function! tlib#World#New(...)
    let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
    call object.SetMatchMode(tlib#var#Get('tlib#input#filter_mode', 'g', 'cnf'))
    return object
endf


" :nodoc:
function! s:prototype.Set_display_format(value) dict "{{{3
    if a:value == 'filename'
        call self.Set_highlight_filename()
        let self.display_format = 'world.FormatFilename(%s)'
    else
        let self.display_format = a:value
    endif
endf


" :nodoc:
function! s:prototype.DisplayFormat(list) dict "{{{3
    let display_format = self.display_format
    if !empty(display_format)
        if has_key(self, 'InitFormatName')
            call self.InitFormatName()
        endif
        let cache = self.fmt_display
        " TLogVAR display_format, fmt_entries
        return map(copy(a:list), 'self.FormatName(cache, display_format, v:val)')
    else
        return a:list
    endif
endf


" :nodoc:
function! s:prototype.Set_highlight_filename() dict "{{{3
    let self.tlib_UseInputListScratch = 'call world.Highlight_filename()'
endf


if g:tlib#input#format_filename == 'r'

    " :nodoc:
    function! s:prototype.Highlight_filename() dict "{{{3
        syntax match TLibDir /\s\+\zs.\{-}[\/]\ze[^\/]\+$/
        hi def link TLibDir Directory
        syntax match TLibFilename /[^\/]\+$/
        hi def link TLibFilename Normal
    endf

    " :nodoc:
    function! s:prototype.FormatFilename(file) dict "{{{3
        if !has_key(self.fmt_options, 'maxlen')
            let maxco = &co - len(len(self.base)) - eval(g:tlib#input#filename_padding_r)
            let maxfi = max(map(copy(self.base), 'strwidth(v:val)'))
            let self.fmt_options.maxlen = min([maxco, maxfi])
            " TLogVAR maxco, maxfi, self.fmt_options.maxlen
        endif
        let max = self.fmt_options.maxlen
        if len(a:file) > max
            let filename = '...' . strpart(a:file, len(a:file) - max + 3)
        else
            let filename = printf('% '. max .'s', a:file)
        endif
        return filename
    endf

else

    " :nodoc:
    function! s:prototype.Highlight_filename() dict "{{{3
        " let self.width_filename = 1 + eval(g:tlib_inputlist_width_filename)
        " TLogVAR self.base
        let self.width_filename = min([
                    \ get(self, 'width_filename', &co),
                    \ empty(g:tlib#input#filename_max_width) ? &co : eval(g:tlib#input#filename_max_width),
                    \ max(map(copy(self.base), 'strwidth(matchstr(v:val, "[^\\/]*$"))'))
                    \ ])
       "  TLogVAR self.width_filename
         exec 'syntax match TLibDir /\%>'. (1 + self.width_filename) .'c \(|\|\[[^]]*\]\) \zs\(\(\a:\|\.\.\|\.\.\..\{-}\)\?[\/][^&<>*|]\{-}\)\?[^\/]\+$/ contained containedin=TLibMarker contains=TLibFilename'
         exec 'syntax match TLibMarker /\%>'. (1 + self.width_filename) .'c \(|\|\[[^]]*\]\) \S.*$/ contains=TLibDir'
       "  exec 'syntax match TLibDir /\(|\|\[.\{-}\]\) \zs\(\(\a:\|\.\.\|\.\.\..\{-}\)\?[\/][^&<>*|]\{-}\)\?[^\/]\+$/ contained containedin=TLibMarker contains=TLibFilename'
       "  exec 'syntax match TLibMarker /\(|\|\[.\{-}\]\) \S.*$/ contains=TLibDir'
        exec 'syntax match TLibFilename /[^\/]\+$/ contained containedin=TLibDir'
        hi def link TLibMarker Special
        hi def link TLibDir Directory
        hi def link TLibFilename NonText
        " :nodoc:
        function! self.Highlighter(rx) dict
            let rx = '/\c\%>'. (1 + self.width_filename) .'c \(|\|\[[^]]*\]\) .\{-}\zs'. escape(a:rx, '/') .'/'
            exec 'match' self.matcher.highlight rx
        endf
    endf


    " :nodoc:
    function! s:prototype.UseFilenameIndicators() dict "{{{3
        return g:tlib_inputlist_filename_indicators || has_key(self, 'filename_indicators')
    endf


    " :nodoc:
    function! s:prototype.InitFormatName() dict "{{{3 
        if self.UseFilenameIndicators()
            let self._buffers = {}
            for bufnr in range(1, bufnr('$'))
                let filename = fnamemodify(bufname(bufnr), ':p')
                " TLogVAR filename
                let bufdef = {
                            \ 'bufnr': bufnr,
                            \ }
                " '&buflisted'
                for opt in ['&modified', '&bufhidden']
                    let bufdef[opt] = getbufvar(bufnr, opt)
                endfor
                let self._buffers[filename] = bufdef
            endfor
        endif
    endf


    " :nodoc:
    function! s:prototype.FormatFilename(file) dict "{{{3
        " TLogVAR a:file
        let width = self.width_filename
        let split = match(a:file, '[/\\]\zs[^/\\]\+$')
        if split == -1
            let fname = a:file
            let dname = a:file
        else
            let fname = strpart(a:file, split)
            " let dname = strpart(a:file, 0, split - 1)
            let dname = a:file
        endif
        if strwidth(fname) > width
            let fname = strpart(fname, 0, width - 3) .'...'
        endif
        let dnmax = &co - max([width, strwidth(fname)]) - 8 - self.index_width - &fdc
        let use_indicators = self.UseFilenameIndicators()
        " TLogVAR use_indicators
        let marker = []
        if use_indicators
            call insert(marker, '[')
            if g:tlib_inputlist_filename_indicators
                let bufdef = get(self._buffers, a:file, {})
                " let bnr = bufnr(a:file)
                let bnr = get(bufdef, 'bufnr', -1)
                " TLogVAR a:file, bnr, self.bufnr
                if bnr != -1
                    if bnr == self.bufnr
                        call add(marker, '%')
                    else
                        call add(marker, bnr)
                    endif
                    if get(bufdef, '&modified', 0)
                        call add(marker, '+')
                    endif
                    if get(bufdef, '&bufhidden', '') == 'hide'
                        call add(marker, 'h')
                    endif
                    " if !get(bufdef, '&buflisted', 1)
                    "     call add(marker, 'u')
                    " endif
                    " echom "DBG" a:file string(get(self,'filename_indicators'))
                endif
            endif
            if has_key(self, 'filename_indicators') && has_key(self.filename_indicators, a:file)
                if len(marker) > 1
                    call add(marker, '|')
                endif
                call add(marker, self.filename_indicators[a:file])
            endif
            if len(marker) <= 1
                call add(marker, ' ')
            endif
            call add(marker, ']')
        else
            call add(marker, '|')
        endif
        let markers = join(marker, '')
        if !empty(markers)
            let dnmax -= len(markers)
        endif
        if strwidth(dname) > dnmax
            let dname = '...'. strpart(dname, len(dname) - dnmax)
        endif
        return printf("%-*s %s %s",
                    \ self.width_filename + len(fname) - strwidth(fname),
                    \ fname, markers, dname)
    endf

endif


" :nodoc:
function! s:prototype.GetSelectedItems(current) dict "{{{3
    " TLogVAR a:current
    if stridx(self.type, 'i') != -1
        let rv = copy(self.sel_idx)
    else
        let rv = map(copy(self.sel_idx), 'self.GetBaseItem(v:val)')
    endif
    if !empty(a:current)
        " TLogVAR a:current, rv, type(a:current)
        if tlib#type#IsNumber(a:current) || tlib#type#IsString(a:current)
            call s:InsertSelectedItems(rv, a:current)
        elseif tlib#type#IsList(a:current)
            for item in a:current
                call s:InsertSelectedItems(rv, item)
            endfor
        elseif tlib#type#IsDictionary(a:current)
            for [inum, item] in items(a:current)
                call s:InsertSelectedItems(rv, item)
            endfor
        endif
    endif
    " TAssert empty(rv) || rv[0] == a:current
    if stridx(self.type, 'i') != -1
        if !empty(self.index_table)
            " TLogVAR rv, self.index_table
            call map(rv, 'self.index_table[v:val - 1]')
            " TLogVAR rv
        endif
    endif
    return rv
endf


function! s:InsertSelectedItems(rv, current) "{{{3
    let ci = index(a:rv, a:current)
    if ci != -1
        call remove(a:rv, ci)
    endif
    call insert(a:rv, a:current)
endf


" :nodoc:
function! s:prototype.SelectItemsByNames(mode, items) dict "{{{3
    for item in a:items
        let bi = index(self.base, item) + 1
        " TLogVAR item, bi
        if bi > 0
            let si = index(self.sel_idx, bi)
            " TLogVAR self.sel_idx
            " TLogVAR si
            if si == -1
                call add(self.sel_idx, bi)
            elseif a:mode == 'toggle'
                call remove(self.sel_idx, si)
            endif
        endif
    endfor
    return 1
endf


" :nodoc:
function! s:prototype.SelectItem(mode, index) dict "{{{3
    let bi = self.GetBaseIdx(a:index)
    " if self.RespondTo('MaySelectItem')
    "     if !self.MaySelectItem(bi)
    "         return 0
    "     endif
    " endif
    " TLogVAR bi
    let si = index(self.sel_idx, bi)
    " TLogVAR self.sel_idx
    " TLogVAR si
    if si == -1
        call add(self.sel_idx, bi)
    elseif a:mode == 'toggle'
        call remove(self.sel_idx, si)
    endif
    return 1
endf


" :nodoc:
function! s:prototype.FormatArgs(format_string, arg) dict "{{{3
    let nargs = len(substitute(a:format_string, '%%\|[^%]', '', 'g'))
    return [a:format_string] + repeat([string(a:arg)], nargs)
endf


" :nodoc:
function! s:prototype.GetRx(filter) dict "{{{3
    return '\('. join(filter(copy(a:filter), 'v:val[0] != "!"'), '\|') .'\)' 
endf


" :nodoc:
function! s:prototype.GetRx0(...) dict "{{{3
    exec tlib#arg#Let(['negative'])
    let rx0 = []
    for filter in self.filter
        " TLogVAR filter
        let rx = join(reverse(filter(copy(filter), '!empty(v:val)')), '\|')
        " TLogVAR rx
        if !empty(rx) && (negative ? rx[0] == g:tlib#input#not : rx[0] != g:tlib#input#not)
            call add(rx0, rx)
        endif
    endfor
    let rx0s = join(rx0, '\|')
    if empty(rx0s)
        return ''
    else
        return self.FilterRxPrefix() .'\('. rx0s .'\)'
    endif
endf


" :nodoc:
function! s:prototype.FormatName(cache, format, value) dict "{{{3
    " TLogVAR a:format, a:value
    " TLogDBG has_key(self.fmt_display, a:value)
    if has_key(a:cache, a:value)
        " TLogDBG "cached"
        return a:cache[a:value]
    else
        let world = self
        let ftpl = self.FormatArgs(a:format, a:value)
        let fn = call(function("printf"), ftpl)
        let fmt = eval(fn)
        " TLogVAR ftpl, fn, fmt
        let a:cache[a:value] = fmt
        return fmt
    endif
endf


" :nodoc:
function! s:prototype.GetItem(idx) dict "{{{3
    return self.list[a:idx - 1]
endf


" :nodoc:
function! s:prototype.GetListIdx(baseidx) dict "{{{3
    " if empty(self.index_table)
        let baseidx = a:baseidx
    " else
    "     let baseidx = 0 + self.index_table[a:baseidx - 1]
    "     " TLogVAR a:baseidx, baseidx, self.index_table 
    " endif
    let rv = index(self.table, baseidx)
    " TLogVAR rv, self.table
    return rv
endf


" :nodoc:
" The first index is 1.
function! s:prototype.GetBaseIdx(idx) dict "{{{3
    " TLogVAR a:idx, self.table, self.index_table
    if !empty(self.table) && a:idx > 0 && a:idx <= len(self.table)
        return self.table[a:idx - 1]
    else
        return 0
    endif
endf


" :nodoc:
function! s:prototype.GetBaseIdx0(idx) dict "{{{3
    let idx0 = self.GetBaseIdx(a:idx) - 1
    if idx0 < 0
        call tlib#notify#Echo('TLIB: Internal Error: GetBaseIdx0: idx0 < 0', 'WarningMsg')
    endif
    return idx0
endf


" :nodoc:
function! s:prototype.GetBaseItem(idx) dict "{{{3
    return self.base[a:idx - 1]
endf


" :nodoc:
function! s:prototype.SetBaseItem(idx, item) dict "{{{3
    let self.base[a:idx - 1] = a:item
endf


" :nodoc:
function! s:prototype.GetLineIdx(lnum) dict "{{{3
    let line = getline(a:lnum)
    let prefidx = substitute(matchstr(line, '^\d\+\ze[*:]'), '^0\+', '', '')
    return prefidx
endf


" :nodoc:
function! s:prototype.SetPrefIdx() dict "{{{3
    " let pref = sort(range(1, self.llen), 'self.SortPrefs')
    " let self.prefidx = get(pref, 0, self.initial_index)
    let pref_idx = -1
    let pref_weight = -1
    " TLogVAR self.filter_pos, self.filter_neg
    for idx in range(1, self.llen)
        let item = self.GetItem(idx)
        let weight = self.matcher.AssessName(self, item)
        " TLogVAR item, weight
        if weight > pref_weight
            let pref_idx = idx
            let pref_weight = weight
        endif
    endfor
    " TLogVAR pref_idx
    " TLogDBG self.GetItem(pref_idx)
    if pref_idx == -1
        let self.prefidx = self.initial_index
    else
        let self.prefidx = pref_idx
    endif
endf


" " :nodoc:
" function! s:prototype.GetCurrentItem() dict "{{{3
"     let idx = self.prefidx
"     " TLogVAR idx
"     if stridx(self.type, 'i') != -1
"         return idx
"     elseif !empty(self.list)
"         if len(self.list) >= idx
"             let idx1 = idx - 1
"             let rv = self.list[idx - 1]
"             " TLogVAR idx, idx1, rv, self.list
"             return rv
"         endif
"     else
"         return ''
"     endif
" endf


" :nodoc:
function! s:prototype.CurrentItem() dict "{{{3
    if stridx(self.type, 'i') != -1
        return self.GetBaseIdx(self.llen == 1 ? 1 : self.prefidx)
    else
        if self.llen == 1
            " TLogVAR self.llen
            return self.list[0]
        elseif self.prefidx > 0
            " TLogVAR self.prefidx
            " return self.GetCurrentItem()
            if len(self.list) >= self.prefidx
                let rv = self.list[self.prefidx - 1]
                " TLogVAR idx, rv, self.list
                return rv
            endif
        else
            return ''
        endif
    endif
endf


" :nodoc:
function! s:prototype.FilterRxPrefix() dict "{{{3
    return self.matcher.FilterRxPrefix()
endf


" :nodoc:
function! s:prototype.SetFilter() dict "{{{3
    " let mrx = '\V'. (a:0 >= 1 && a:1 ? '\C' : '')
    let mrx = self.FilterRxPrefix() . self.filter_options
    let self.filter_pos = []
    let self.filter_neg = []
    " TLogVAR mrx, self.filter
    for filter in self.filter
        " TLogVAR filter
        let rx = join(reverse(filter(copy(filter), '!empty(v:val)')), '\|')
        " TLogVAR rx
        if !empty(rx)
            if rx =~ '\u'
                let mrx1 = mrx .'\C'
            else
                let mrx1 = mrx
            endif
            " TLogVAR rx
            if rx[0] == g:tlib#input#not
                if len(rx) > 1
                    call add(self.filter_neg, mrx1 .'\('. rx[1:-1] .'\)')
                endif
            else
                call add(self.filter_pos, mrx1 .'\('. rx .'\)')
            endif
        endif
    endfor
    " TLogVAR self.filter_pos, self.filter_neg
endf


" :nodoc:
function! s:prototype.IsValidFilter() dict "{{{3
    let last = self.FilterRxPrefix() .'\('. self.filter[0][0] .'\)'
    " TLogVAR last
    try
        let a = match("", last)
        return 1
    catch
        return 0
    endtry
endf


" :nodoc:
function! s:prototype.SetMatchMode(match_mode) dict "{{{3
    " TLogVAR a:match_mode
    if !empty(a:match_mode)
        unlet self.matcher
        try
            let self.matcher = tlib#Filter_{a:match_mode}#New()
            call self.matcher.Init(self)
        catch /^Vim\%((\a\+)\)\=:E117/
            throw 'tlib: Unknown mode for tlib#input#filter_mode: '. a:match_mode
        endtry
    endif
endf


" function! s:prototype.Match(text) dict "{{{3
"     return self.matcher.Match(self, text)
" endf


" :nodoc:
function! s:prototype.MatchBaseIdx(idx) dict "{{{3
    let text = self.GetBaseItem(a:idx)
    if !empty(self.filter_format)
        let text = self.FormatName(self.fmt_filter, self.filter_format, text)
    endif
    " TLogVAR text
    " return self.Match(text)
    return self.matcher.Match(self, text)
endf


" :nodoc:
function! s:prototype.BuildTableList() dict "{{{3
    " let time0 = str2float(reltimestr(reltime()))  " DBG
    " TLogVAR time0
    call self.SetFilter()
    " TLogVAR self.filter_neg, self.filter_pos
    let self.table = range(1, len(self.base))
    " TLogVAR self.filtered_items
    let copy_base = 1
    if !empty(self.filtered_items)
        let self.table = filter(self.table, 'index(self.filtered_items, v:val) != -1')
        let copy_base = 0
    endif
    if !empty(self.filter_pos) || !empty(self.filter_neg)
        let self.table = filter(self.table, 'self.MatchBaseIdx(v:val)')
        let copy_base = 0
    endif
    if copy_base
        let self.list = copy(self.base)
    else
        let self.list  = map(copy(self.table), 'self.GetBaseItem(v:val)')
    endif
endf


" :nodoc:
function! s:prototype.ReduceFilter() dict "{{{3
    " TLogVAR self.filter
    if self.filter[0] == [''] && len(self.filter) > 1
        call remove(self.filter, 0)
    elseif empty(self.filter[0][0]) && len(self.filter[0]) > 1
        call remove(self.filter[0], 0)
    else
        call self.matcher.ReduceFrontFilter(self)
    endif
endf


" :nodoc:
" filter is either a string or a list of list of strings.
function! s:prototype.SetInitialFilter(filter) dict "{{{3
    " let self.initial_filter = [[''], [a:filter]]
    if type(a:filter) == 3
        let self.initial_filter = copy(a:filter)
    else
        let self.initial_filter = [[a:filter]]
    endif
endf


" :nodoc:
function! s:prototype.PopFilter() dict "{{{3
    " TLogVAR self.filter
    if len(self.filter[0]) > 1
        call remove(self.filter[0], 0)
    elseif len(self.filter) > 1
        call remove(self.filter, 0)
    else
        let self.filter[0] = ['']
    endif
endf


" :nodoc:
function! s:prototype.FilterIsEmpty() dict "{{{3
    " TLogVAR self.filter
    return self.filter == copy(self.initial_filter)
endf


" :nodoc:
function! s:prototype.DisplayFilter() dict "{{{3
    let filter1 = copy(self.filter)
    call filter(filter1, 'v:val != [""]')
    " TLogVAR self.matcher['_class']
    let rv = self.matcher.DisplayFilter(filter1)
    let rv = self.CleanFilter(rv)
    return rv
endf


" :nodoc:
function! s:prototype.SetFrontFilter(pattern) dict "{{{3
    call self.matcher.SetFrontFilter(self, a:pattern)
endf


" :nodoc:
function! s:prototype.PushFrontFilter(char) dict "{{{3
    call self.matcher.PushFrontFilter(self, a:char)
endf


" :nodoc:
function! s:prototype.CleanFilter(filter) dict "{{{3
    return self.matcher.CleanFilter(a:filter)
endf


" :nodoc:
function! s:prototype.UseScratch() dict "{{{3
    " if type(self.scratch) != 0 && get(self, 'buffer_local', 1)
    "     if self.scratch != fnamemodify(self.scratch, ':p')
    "         let self.scratch = tlib#file#Join([expand('%:p:h'), self.scratch])
    "         " TLogVAR self.scratch
    "     endif
    "     " let self.scratch_hidden = 'wipe'
    " endif
    keepjumps keepalt let rv = tlib#scratch#UseScratch(self)
    " if expand('%:t') == self.scratch
        let b:tlib_world = self
    " endif
    return rv
endf


" :nodoc:
function! s:prototype.CloseScratch(...) dict "{{{3
    TVarArg ['reset_scratch', 0]
    " TVarArg ['reset_scratch', 1]
    " TLogVAR reset_scratch
    if self.sticky
        return 0
    else
        let rv = tlib#scratch#CloseScratch(self, reset_scratch)
        " TLogVAR rv
        if rv
            call self.SwitchWindow('win')
        endif
        return rv
    endif
endf


" :nodoc:
function! s:prototype.Initialize() dict "{{{3
    let self.initialized = 1
    call self.SetOrigin(1)
    call self.Reset(1)
    if !empty(self.cache_var) && exists(self.cache_var)
        for prop in self.restore_from_cache
            exec 'let self[prop] = get('. self.cache_var .', prop, self[prop])'
        endfor
        exec 'unlet '. self.cache_var
    endif
endf


" :nodoc:
function! s:prototype.Leave() dict "{{{3
    if !empty(self.cache_var)
        exec 'let '. self.cache_var .' = self'
    endif
    for handler in self.on_leave
        call call(handler, [self])
    endfor
endf


" :nodoc:
function! s:prototype.UseInputListScratch() dict "{{{3
    let scratch = self.UseScratch()
    if !exists('b:tlib_list_init')
        call tlib#autocmdgroup#Init()
        autocmd TLib VimResized <buffer> call feedkeys("\<c-j>", 't')
        " autocmd TLib WinLeave <buffer> let b:tlib_world_event = 'WinLeave' | call feedkeys("\<c-j>", 't')
        let b:tlib_list_init = 1
    endif
    if !exists('w:tlib_list_init')
        " TLogVAR scratch
        syntax match InputlListIndex /^\d\+:/
        syntax match InputlListCursor /^\d\+\* .*$/ contains=InputlListIndex
        syntax match InputlListSelected /^\d\+# .*$/ contains=InputlListIndex
        hi def link InputlListIndex Constant
        hi def link InputlListCursor Search
        hi def link InputlListSelected IncSearch
        setlocal nowrap
        " hi def link InputlListIndex Special
        " let b:tlibDisplayListMarks = {}
        let b:tlibDisplayListMarks = []
        let b:tlibDisplayListWorld = self
        call tlib#hook#Run('tlib_UseInputListScratch', self)
        let w:tlib_list_init = 1
    endif
    return scratch
endf


" s:prototype.Reset(?initial=0)
" :nodoc:
function! s:prototype.Reset(...) dict "{{{3
    TVarArg ['initial', 0]
    " TLogVAR initial
    let self.state     = 'display'
    let self.offset    = 1
    let self.filter    = deepcopy(self.initial_filter)
    let self.idx       = ''
    let self.prefidx   = 0
    let self.initial_display = 1
    let self.fmt_display = {}
    let self.fmt_filter = {}
    call self.UseInputListScratch()
    call self.ResetSelected()
    call self.Retrieve(!initial)
    return self
endf


" :nodoc:
function! s:prototype.ResetSelected() dict "{{{3
    let self.sel_idx   = []
endf


" :nodoc:
function! s:prototype.Retrieve(anyway) dict "{{{3
    " TLogVAR a:anyway, self.base
    " TLogDBG (a:anyway || empty(self.base))
    if (a:anyway || empty(self.base))
        let ra = self.retrieve_eval
        " TLogVAR ra
        if !empty(ra)
            let back  = self.SwitchWindow('win')
            let world = self
            let self.base = eval(ra)
            " TLogVAR self.base
            exec back
            return 1
        endif
    endif
    return 0
endf


function! s:FormatHelp(help) "{{{3
    " TLogVAR a:help
    let max = [0, 0]
    for item in a:help
        " TLogVAR item
        if type(item) == 3
            let itemlen = map(copy(item), 'strwidth(v:val)')
            " TLogVAR itemlen
            let max = map(range(2), 'max[v:val] >= itemlen[v:val] ? max[v:val] : itemlen[v:val]')
        endif
        unlet item
    endfor
    " TLogVAR max
    let cols = float2nr((winwidth(0) - &foldcolumn - 1) / (max[0] + max[1] + 2))
    if cols < 1
        let cols = 1
    endif
    let fmt = printf('%%%ds: %%-%ds', max[0], max[1])
    " TLogVAR cols, fmt
    let help = []
    let idx = -1
    let maxidx = len(a:help)
    while idx < maxidx
        let push_item = 0
        let accum = []
        for i in range(cols)
            let idx += 1
            if idx >= maxidx
                break
            endif
            let item = a:help[idx]
            if type(item) == 3
                call add(accum, item)
            else
                let push_item = 1
                break
            endif
            unlet item
        endfor
        if !empty(accum)
            call add(help, s:FormatHelpItem(accum, fmt))
        endif
        if push_item
            call add(help, a:help[idx])
        endif
    endwh
    " TLogVAR help
    return help
endf


function! s:FormatHelpItem(item, fmt) "{{{3
    let args = [join(repeat([a:fmt], len(a:item)), '  ')]
    for item in a:item
        " TLogVAR item
        let args += item
    endfor
    " TLogVAR args
    return call('printf', args)
endf


" :nodoc:
function! s:prototype.InitHelp() dict "{{{3
    return []
endf


" :nodoc:
function! s:prototype.PushHelp(...) dict "{{{3
    " TLogVAR a:000
    if a:0 == 1
        if type(a:1) == 3
            let self.temp_lines += a:1
        else
            call add(self.temp_lines, a:1)
        endif
    elseif a:0 == 2
        call add(self.temp_lines, a:000)
    else
        throw "TLIB: PushHelp: Wrong number of arguments: ". string(a:000)
    endif
    " TLogVAR helpstring
endf


" :nodoc:
function! s:prototype.DisplayHelp() dict "{{{3
    let self.temp_lines = self.InitHelp()
    call self.PushHelp('<Esc>', self.key_mode == 'default' ? 'Abort' : 'Reset keymap')
    call self.PushHelp('Enter, <cr>', 'Pick the current item')
    call self.PushHelp('Mouse', 'L: Pick item, R: Show menu')
    call self.PushHelp('<M-Number>',  'Select an item')
    call self.PushHelp('<BS>, <C-BS>', 'Reduce filter')
    call self.PushHelp('<S-Esc>, <F10>', 'Enter command')

    if self.key_mode == 'default'
        call self.PushHelp('<C|M-r>',      'Reset the display')
        call self.PushHelp('Up/Down',      'Next/previous item')
        call self.PushHelp('<C|M-q>',      'Edit top filter string')
        call self.PushHelp('Page Up/Down', 'Scroll')
        call self.PushHelp('<S-Space>',    'Enter * Wildcard')
        if self.allow_suspend
            call self.PushHelp('<C|M-z>', 'Suspend/Resume')
            call self.PushHelp('<C-o>', 'Switch to origin')
        endif
        if stridx(self.type, 'm') != -1
            call self.PushHelp('<S-Up/Down>', '(Un)Select items')
            call self.PushHelp('#, <C-Space>', '(Un)Select the current item')
            call self.PushHelp('<C|M-a>', '(Un)Select all items')
            call self.PushHelp('<F9>', '(Un)Restrict view to selection')
            " \ '<c-\>        ... Show only selected',
        endif
    endif

    " TLogVAR len(self.temp_lines)
    call self.matcher.Help(self)

    " TLogVAR self.key_mode
    for handler in values(self.key_map[self.key_mode])
        " TLogVAR handler
        let key = get(handler, 'key_name', '')
        " TLogVAR key
        if !empty(key)
            let desc = get(handler, 'help', '')
            if empty(desc)
                let desc = get(handler, 'agent', '')
            endif
            call self.PushHelp(key, desc)
        endif
    endfor

    if !has_key(self.key_map[self.key_mode], 'unknown_key')
        call self.PushHelp('Letter', 'Filter the list')
    endif

    if self.key_mode == 'default' && !empty(self.help_extra)
        call self.PushHelp(self.help_extra)
    endif

    " TLogVAR len(self.temp_lines)
    call self.PushHelp([
                \ '',
                \ 'Matches at word boundaries are prioritized.',
                \ ])
    let self.temp_lines = s:FormatHelp(self.temp_lines)
    call self.PrintLines()
endf


function! s:prototype.PrintLines() dict "{{{3
    let self.temp_prompt = ['Press any key to continue.', 'Question']
    call tlib#buffer#DeleteRange('1', '$')
    call append(0, self.temp_lines)
    call tlib#buffer#DeleteRange('$', '$')
    1
    call self.Resize(len(self.temp_lines), 0)
    let self.temp_lines = []
endf


" :nodoc:
function! s:prototype.Resize(hsize, vsize) dict "{{{3
    " TLogVAR self.scratch_vertical, a:hsize, a:vsize
    let world_resize = ''
    let winpos = ''
    let scratch_split = get(self, 'scratch_split', 1)
    " TLogVAR scratch_split
    if scratch_split > 0
        if self.scratch_vertical
            if a:vsize
                let world_resize = 'vert resize '. a:vsize
                let winpos = tlib#fixes#Winpos()
                " let w:winresize = {'v': a:vsize}
                setlocal winfixwidth
            endif
        else
            if a:hsize
                let world_resize = 'resize '. a:hsize
                " let w:winresize = {'h': a:hsize}
                setlocal winfixheight
            endif
        endif
    endif
    if !empty(world_resize)
        " TLogVAR world_resize, winpos
        exec world_resize
        if !empty(winpos)
            exec winpos
        endif
        " redraw!
    endif
endf


" :nodoc:
function! s:prototype.GetResize(size) dict "{{{3
    let resize0 = get(self, 'resize', 0)
    let resize = empty(resize0) ? 0 : eval(resize0)
    " TLogVAR resize0, resize
    let resize = resize == 0 ? a:size : min([a:size, resize])
    " let min = self.scratch_vertical ? &cols : &lines
    let min1 = (self.scratch_vertical ? self.win_width : self.win_height) * g:tlib_inputlist_pct
    let min2 = (self.scratch_vertical ? &columns : &lines) * self.win_pct
    let min = max([min1, min2])
    let resize = min([resize, (min / 100)])
    " TLogVAR resize, a:size, min, min1, min2
    return resize
endf


" function! s:prototype.DisplayList(?query=self.Query(), ?list=[])
" :nodoc:
function! s:prototype.DisplayList(...) dict "{{{3
    " TLogVAR self.state
    let query = a:0 >= 1 ? a:1 : self.Query()
    let list = a:0 >= 2 ? a:2 : []
    " TLogVAR query, len(list)
    " TLogDBG 'len(list) = '. len(list)
    call self.UseScratch()
    " TLogVAR self.scratch
    " TAssert IsNotEmpty(self.scratch)
    if self.state == 'scroll'
        call self.ScrollToOffset()
    elseif self.state == 'help'
        call self.DisplayHelp()
        call self.SetStatusline(query)
    elseif self.state == 'printlines'
        call self.PrintLines()
        call self.SetStatusline(query)
    else
        " TLogVAR query
        " let ll = len(list)
        let ll = self.llen
        " let x  = len(ll) + 1
        let x  = self.index_width + 1
        " TLogVAR ll
        if self.state =~ '\<display\>'
            call self.Resize(self.GetResize(ll), eval(get(self, 'resize_vertical', 0)))
            call tlib#normal#WithRegister('gg"tdG', 't')
            let w = winwidth(0) - &fdc
            " let w = winwidth(0) - &fdc - 1
            let lines = copy(list)
            let lines = map(lines, 'printf("%-'. w .'.'. w .'s", substitute(v:val, ''[[:cntrl:][:space:]]'', " ", "g"))')
            " TLogVAR lines
            call append(0, lines)
            call tlib#normal#WithRegister('G"tddgg', 't')
        endif
        " TLogVAR self.prefidx
        let base_pref = self.GetBaseIdx(self.prefidx)
        " TLogVAR base_pref
        if self.state =~ '\<redisplay\>'
            call filter(b:tlibDisplayListMarks, 'index(self.sel_idx, v:val) == -1 && v:val != base_pref')
            " TLogVAR b:tlibDisplayListMarks
            call map(b:tlibDisplayListMarks, 'self.DisplayListMark(x, v:val, ":")')
            " let b:tlibDisplayListMarks = map(copy(self.sel_idx), 'self.DisplayListMark(x, v:val, "#")')
            " call add(b:tlibDisplayListMarks, self.prefidx)
            " call self.DisplayListMark(x, self.GetBaseIdx(self.prefidx), '*')
        endif
        let b:tlibDisplayListMarks = map(copy(self.sel_idx), 'self.DisplayListMark(x, v:val, "#")')
        call add(b:tlibDisplayListMarks, base_pref)
        call self.DisplayListMark(x, base_pref, '*')
        call self.SetOffset()
        call self.SetStatusline(query)
        " TLogVAR self.offset
        call self.ScrollToOffset()
        let rx0 = self.GetRx0()
        " TLogVAR rx0
        if !empty(self.matcher.highlight)
            if empty(rx0)
                match none
            elseif self.IsValidFilter()
                if has_key(self, 'Highlighter')
                    call self.Highlighter(rx0)
                else
                    exec 'match '. self.matcher.highlight .' /\c'. escape(rx0, '/') .'/'
                endif
            endif
        endif
    endif
    redraw
endf


" :nodoc:
function! s:prototype.SetStatusline(query) dict "{{{3
    " TLogVAR a:query
    if !empty(self.temp_prompt)
        let echo = get(self.temp_prompt, 0, '')
        let hl = get(self.temp_prompt, 1, 'Normal')
        let self.temp_prompt = []
    else
        let hl = 'Normal'
        let query   = a:query
        let options = [self.matcher.name]
        if self.sticky
            call add(options, '#')
        endif
        if self.key_mode != 'default'
            call add(options, 'map:'. self.key_mode)
        endif
        if !empty(self.filtered_items)
            if g:tlib_inputlist_shortmessage
                call add(options, 'R')
            else
                call add(options, 'restricted')
            endif
        endif
        if !empty(options)
            let sopts = printf('[%s]', join(options, ', '))
            " let echo  = query . repeat(' ', &columns - len(sopts) - len(query) - 20) . sopts
            let echo  = query . '  ' . sopts
            " let query .= '%%='. sopts .' '
        endif
        " TLogVAR &l:statusline, query
        " let &l:statusline = query
    endif
    echo
    if hl != 'Normal'
        exec 'echohl' hl
        echo echo
        echohl None
    else
        echo echo
    endif
endf


" :nodoc:
function! s:prototype.Query() dict "{{{3
    if g:tlib_inputlist_shortmessage
        let query = 'Filter: '. self.DisplayFilter()
    else
        let query = self.query .' (filter: '. self.DisplayFilter() .'; press <F1> for help)'
    endif
    return query
endf


" :nodoc:
function! s:prototype.ScrollToOffset() dict "{{{3
    " TLogVAR self.scratch_vertical, self.llen, winheight(0)
    exec 'norm! '. self.offset .'zt'
endf


" :nodoc:
function! s:prototype.SetOffset() dict "{{{3
    " TLogVAR self.prefidx, self.offset
    " TLogDBG winheight(0)
    " TLogDBG self.prefidx > self.offset + winheight(0) - 1
    let listtop = len(self.list) - winheight(0) + 1
    if listtop < 1
        let listtop = 1
    endif
    if self.prefidx > listtop
        let self.offset = listtop
    elseif self.prefidx > self.offset + winheight(0) - 1
        let listoff = self.prefidx - winheight(0) + 1
        let self.offset = min([listtop, listoff])
    "     TLogVAR self.prefidx
    "     TLogDBG len(self.list)
    "     TLogDBG winheight(0)
    "     TLogVAR listtop, listoff, self.offset
    elseif self.prefidx < self.offset
        let self.offset = self.prefidx
    endif
    " TLogVAR self.offset
endf


" :nodoc:
function! s:prototype.ClearAllMarks() dict "{{{3
    let x = self.index_width + 1
    call map(range(1, line('$')), 'self.DisplayListMark(x, v:val, ":")')
endf


" :nodoc:
function! s:prototype.MarkCurrent(y) dict "{{{3
    let x = self.index_width + 1
    call self.DisplayListMark(x, a:y, '*')
endf


" :nodoc:
function! s:prototype.DisplayListMark(x, y, mark) dict "{{{3
    " TLogVAR a:y, a:mark
    if a:x > 0 && a:y >= 0
        " TLogDBG a:x .'x'. a:y .' '. a:mark
        let sy = self.GetListIdx(a:y) + 1
        " TLogVAR sy
        if sy >= 1
            call setpos('.', [0, sy, a:x, 0])
            exec 'norm! r'. a:mark
            " exec 'norm! '. a:y .'gg'. a:x .'|r'. a:mark
        endif
    endif
    return a:y
endf


" :nodoc:
function! s:prototype.SwitchWindow(where) dict "{{{3
    " TLogDBG string(tlib#win#List())
    if self.tabpagenr != tabpagenr()
        call tlib#tab#Set(self.tabpagenr)
    endif
    let wnr = get(self, a:where.'_wnr')
    " TLogVAR self, wnr
    return tlib#win#Set(wnr)
endf


" :nodoc:
function! s:prototype.FollowCursor() dict "{{{3
    if !empty(self.follow_cursor)
        let back = self.SwitchWindow('win')
        " TLogVAR back
        " TLogDBG winnr()
        try
            call call(self.follow_cursor, [self, [self.CurrentItem()]])
        finally
            exec back
        endtry
    endif
endf


" :nodoc:
function! s:prototype.SetOrigin(...) dict "{{{3
    TVarArg ['winview', 0]
    " TLogVAR self.win_wnr, self.bufnr
    " TLogDBG bufname('%')
    " TLogDBG winnr()
    " TLogDBG winnr('$')
    let self.win_wnr = winnr()
    let self.win_height = winheight(self.win_wnr)
    let self.win_width = winwidth(self.win_wnr)
    " TLogVAR self.win_wnr, self.win_height, self.win_width
    let self.bufnr   = bufnr('%')
    let self.tabpagenr = tabpagenr()
    let self.cursor  = getpos('.')
    if winview
        let self.winview = tlib#win#GetLayout()
    endif
    " TLogVAR self.win_wnr, self.bufnr, self.winview
    return self
endf


" :nodoc:
function! s:prototype.RestoreOrigin(...) dict "{{{3
    TVarArg ['winview', 0]
    if winview
        " TLogVAR winview
        call tlib#win#SetLayout(self.winview)
    endif
    " TLogVAR self.win_wnr, self.bufnr, self.cursor, &splitbelow
    " TLogDBG "RestoreOrigin0 ". string(tlib#win#List())
    " If &splitbelow or &splitright is false, we cannot rely on 
    " self.win_wnr to be our source buffer since, e.g, opening a buffer 
    " in a split window changes the whole layout.
    " Possible solutions:
    " - Restrict buffer switching to cases when the number of windows 
    "   hasn't changed.
    " - Guess the right window, which we try to do here.
    if &splitbelow == 0 || &splitright == 0
        let wn = bufwinnr(self.bufnr)
        " TLogVAR wn
        if wn == -1
            let wn = 1
        end
    else
        let wn = self.win_wnr
    endif
    if wn != winnr()
        exec wn .'wincmd w'
    endif
    exec 'buffer! '. self.bufnr
    call setpos('.', self.cursor)
    " TLogDBG "RestoreOrigin1 ". string(tlib#win#List())
endf


function! s:prototype.Suspend() dict "{{{3
    call tlib#agent#Suspend(self, self.rv)
endf

autoload/tlib/tab.vim	[[[1
57
" tab.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-08-27.
" @Last Change: 2014-02-06.
" @Revision:    0.0.30

if &cp || exists("loaded_tlib_tab_autoload")
    finish
endif
let loaded_tlib_tab_autoload = 1


" Return a dictionary of bufnumbers => [[tabpage, winnr] ...]
function! tlib#tab#BufMap() "{{{3
    let acc = {}
    for t in range(tabpagenr('$'))
        let bb = tabpagebuflist(t + 1)
        for b in range(len(bb))
            let bn = bb[b]
            let bd = [t + 1, b + 1]
            if has_key(acc, bn)
                call add(acc[bn], bd)
            else
                let acc[bn] = [bd]
            endif
        endfor
    endfor
    return acc
endf


" Find a buffer's window at some tab page.
function! tlib#tab#TabWinNr(buffer) "{{{3
    let bn = bufnr(a:buffer)
    let bt = tlib#tab#BufMap()
    let tn = tabpagenr()
    let wn = winnr()
    let bc = get(bt, bn)
    if !empty(bc)
        for [t, w] in bc
            if t == tn
                return [t, w]
            endif
        endfor
        return bc[0]
    endif
endf


function! tlib#tab#Set(tabnr) "{{{3
    if a:tabnr > 0
        exec a:tabnr .'tabnext'
    endif
endf

autoload/tlib/date.vim	[[[1
120
" date.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-03-25.
" @Last Change: 2010-09-17.
" @Revision:    0.0.34


if !exists('g:tlib#date#ShortDatePrefix') | let g:tlib#date#ShortDatePrefix = '20' | endif "{{{2
if !exists('g:tlib#date#TimeZoneShift')   | let g:tlib#date#TimeZoneShift = 0      | endif "{{{2

let g:tlib#date#dayshift = 60 * 60 * 24


" :display: tlib#date#DiffInDays(date1, ?date2=localtime(), ?allow_zero=0)
function! tlib#date#DiffInDays(date, ...)
    let allow_zero = a:0 >= 2 ? a:2 : 0
    let s0 = tlib#date#SecondsSince1970(a:date, 0, allow_zero)
    let s1 = a:0 >= 1 ? tlib#date#SecondsSince1970(a:1, 0, allow_zero) : localtime()
    let dd = (s0 - s1) / g:tlib#date#dayshift
    " TLogVAR dd
    return dd
endf


" :display: tlib#date#Parse(date, ?allow_zero=0) "{{{3
function! tlib#date#Parse(date, ...) "{{{3
    let min = a:0 >= 1 && a:1 ? 0 : 1
    " TLogVAR a:date, min
    let m = matchlist(a:date, '^\(\d\{2}\|\d\{4}\)-\(\d\{1,2}\)-\(\d\{1,2}\)$')
    if !empty(m)
        let year = m[1]
        let month = m[2]
        let days = m[3]
    else
        let m = matchlist(a:date, '^\(\d\+\)/\(\d\{1,2}\)/\(\d\{1,2}\)$')
        if !empty(m)
            let year = m[1]
            let month = m[3]
            let days = m[2]
        else
            let m = matchlist(a:date, '^\(\d\{1,2}\)\.\s*\(\d\{1,2}\)\.\s*\(\d\d\{2}\|\d\{4}\)$')
            if !empty(m)
                let year = m[3]
                let month = m[2]
                let days = m[1]
            endif
        endif
    endif
    if empty(m) || year == '' || month == '' || days == '' || 
                \ month < min || month > 12 || days < min || days > 31
        echoerr 'TLib: Invalid date: '. a:date
        return []
    endif
    if strlen(year) == 2
        let year = g:tlib#date#ShortDatePrefix . year
    endif
    return [0 + year, 0 + month, 0 + days]
endf


" tlib#date#SecondsSince1970(date, ?daysshift=0, ?allow_zero=0)
function! tlib#date#SecondsSince1970(date, ...) "{{{3
    let allow_zero = a:0 >= 2 ? a:2 : 0
    " TLogVAR a:date, allow_zero
    let date = tlib#date#Parse(a:date, allow_zero)
    if empty(date)
        return 0
    endif
    let [year, month, days] = date
    if a:0 >= 1 && a:1 > 0
        let days = days + a:1
    end
    let days_passed = days
    let i = 1970
    while i < year
        let days_passed = days_passed + 365
        if i % 4 == 0 || i == 2000
            let days_passed = days_passed + 1
        endif
        let i = i + 1
    endwh
    let i = 1
    while i < month
        if i == 1
            let days_passed = days_passed + 31
        elseif i == 2
            let days_passed = days_passed + 28
            if year % 4 == 0 || year == 2000
                let days_passed = days_passed + 1
            endif
        elseif i == 3
            let days_passed = days_passed + 31
        elseif i == 4
            let days_passed = days_passed + 30
        elseif i == 5
            let days_passed = days_passed + 31
        elseif i == 6
            let days_passed = days_passed + 30
        elseif i == 7
            let days_passed = days_passed + 31
        elseif i == 8
            let days_passed = days_passed + 31
        elseif i == 9
            let days_passed = days_passed + 30
        elseif i == 10
            let days_passed = days_passed + 31
        elseif i == 11
            let days_passed = days_passed + 30
        endif
        let i = i + 1
    endwh
    let seconds = (days_passed - 1) * 24 * 60 * 60
    let seconds = seconds + (strftime('%H') + g:tlib#date#TimeZoneShift) * 60 * 60
    let seconds = seconds + strftime('%M') * 60
    let seconds = seconds + strftime('%S')
    return seconds
endf

autoload/tlib/type.vim	[[[1
29
" type.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-30.
" @Last Change: 2010-09-27.
" @Revision:    0.0.4

function! tlib#type#IsNumber(expr)
    return type(a:expr) == 0
endf

function! tlib#type#IsString(expr)
    return type(a:expr) == 1
endf

function! tlib#type#IsFuncref(expr)
    return type(a:expr) == 2
endf

function! tlib#type#IsList(expr)
    return type(a:expr) == 3
endf

function! tlib#type#IsDictionary(expr)
    return type(a:expr) == 4
endf


autoload/tlib/Filter_fuzzy.vim	[[[1
83
" Filter_fuzzy.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-11-25.
" @Last Change: 2013-09-25.
" @Revision:    0.0.47

let s:prototype = tlib#Filter_cnf#New({'_class': ['Filter_fuzzy'], 'name': 'fuzzy'}) "{{{2
let s:prototype.highlight = g:tlib#input#higroup


" Support for "fuzzy" pattern matching in |tlib#input#List()|. 
" Patterns are interpreted as if characters were connected with '.\{-}'.
"
" In "fuzzy" mode, the pretty printing of filenames is disabled.
function! tlib#Filter_fuzzy#New(...) "{{{3
    let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
    return object
endf


" :nodoc:
function! s:prototype.Init(world) dict "{{{3
    " TLogVAR a:world.display_format
    " :nodoc:
    function! a:world.Set_display_format(value) dict
        if a:value == 'filename'
            let self.display_format = ''
        else
            let self.display_format = a:value
        endif
    endf
endf


let s:Help = s:prototype.Help

" :nodoc:
function! s:prototype.Help(world) dict "{{{3
    call call(s:Help, [a:world], self)
    call a:world.PushHelp('Patterns are interpreted as if characters were connected with .\{-}')
endf


" :nodoc:
function! s:prototype.DisplayFilter(filter) dict "{{{3
    " TLogVAR a:filter
    let filter1 = deepcopy(a:filter)
    call map(filter1, '"{". join(reverse(v:val), " OR ") ."}"')
    return join(reverse(filter1), ' AND ')
endf


" :nodoc:
function! s:prototype.SetFrontFilter(world, pattern) dict "{{{3
    let a:world.filter[0] = map(reverse(split(a:pattern, '\s*|\s*')), 'join(map(split(v:val, ''\zs''), ''tlib#rx#Escape(v:val, "V")''), ''\.\{-}'')') + a:world.filter[0][1 : -1]
    endif
endf


" :nodoc:
function! s:prototype.PushFrontFilter(world, char) dict "{{{3
    let ch = tlib#rx#Escape(nr2char(a:char), 'V')
    if empty(a:world.filter[0][0])
        let a:world.filter[0][0] .= ch
    else
        let a:world.filter[0][0] .= '\.\{-}'. ch
    endif
endf


" :nodoc:
function! s:prototype.ReduceFrontFilter(world) dict "{{{3
    let a:world.filter[0][0] = substitute(a:world.filter[0][0], '\(\\\.\\{-}\)\?.$', '', '')
endf


" :nodoc:
function! s:prototype.CleanFilter(filter) dict "{{{3
    return substitute(a:filter, '\\\.\\{-}', '', 'g')
endf

autoload/tlib/textobjects.vim	[[[1
45
" textobjects.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-01-09.
" @Last Change: 2010-01-10.
" @Revision:    0.0.29

let s:save_cpo = &cpo
set cpo&vim


" :tag: standard-paragraph
" Select a "Standard Paragraph", i.e. a text block followed by blank 
" lines. Other than |ap|, the last paragraph in a document is handled 
" just the same.
"
" The |text-object| can be accessed as "sp". Example: >
"
"   vsp ... select the current standard paragraph
"
" Return 1, if the paragraph is the last one in the document.
function! tlib#textobjects#StandardParagraph() "{{{3
    if line("'}") == line('$')
        norm! vip
        return 1
    else
        norm! vap
        return 0
    endif
endf


function! tlib#textobjects#Init() "{{{3
    if !exists('s:tlib_done_textobjects')
        " sp ... Standard paragraph (for use as |text-objects|).
        vnoremap <silent> sp <Esc>:call tlib#textobjects#StandardParagraph()<CR>
        onoremap <silent> sp :<C-u>normal Vsp<CR>
        let s:tlib_done_textobjects = 1
    endif
endf


let &cpo = s:save_cpo
unlet s:save_cpo
autoload/tlib/arg.vim	[[[1
102
" arg.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2009-02-15.
" @Revision:    0.0.50

if &cp || exists("loaded_tlib_arg_autoload")
    finish
endif
let loaded_tlib_arg_autoload = 1


" :def: function! tlib#arg#Get(n, var, ?default="", ?test='')
" Set a positional argument from a variable argument list.
" See tlib#string#RemoveBackslashes() for an example.
function! tlib#arg#Get(n, var, ...) "{{{3
    let default = a:0 >= 1 ? a:1 : ''
    let atest   = a:0 >= 2 ? a:2 : ''
    " TLogVAR default, atest
    if !empty(atest)
        let atest = ' && (a:'. a:n .' '. atest .')'
    endif
    let test = printf('a:0 >= %d', a:n) . atest
    return printf('let %s = %s ? a:%d : %s', a:var, test, a:n, string(default))
endf


" :def: function! tlib#arg#Let(list, ?default='')
" Set a positional arguments from a variable argument list.
" See tlib#input#List() for an example.
function! tlib#arg#Let(list, ...) "{{{3
    let default = a:0 >= 1 ? a:1 : ''
    let list = map(copy(a:list), 'type(v:val) == 3 ? v:val : [v:val, default]')
    let args = map(range(1, len(list)), 'call("tlib#arg#Get", [v:val] + list[v:val - 1])')
    return join(args, ' | ')
endf


" :def: function! tlib#arg#Key(dict, list, ?default='')
" See |:TKeyArg|.
function! tlib#arg#Key(list, ...) "{{{3
    let default = a:0 >= 1 ? a:1 : ''
    let dict = a:list[0]
    let list = map(copy(a:list[1:-1]), 'type(v:val) == 3 ? v:val : [v:val, default]')
    let args = map(list, '"let ". v:val[0] ." = ". string(get(dict, v:val[0], v:val[1]))')
    " TLogVAR dict, list, args
    return join(args, ' | ')
endf


" :def: function! tlib#arg#StringAsKeyArgs(string, ?keys=[], ?evaluate=0)
function! tlib#arg#StringAsKeyArgs(string, ...) "{{{1
    TVarArg ['keys', {}], ['evaluate', 0]
    let keyargs = {}
    let args = split(a:string, '\\\@<! ')
    let arglist = map(args, 'matchlist(v:val, ''^\(\w\+\):\(.*\)$'')')
    " TLogVAR a:string, args, arglist
    for matchlist in arglist
        if len(matchlist) < 3
            throw 'Malformed key arguments: '. string(matchlist) .' in '. a:string
        endif
        let [match, key, val; rest] = matchlist
        if empty(keys) || has_key(keys, key)
            let val = substitute(val, '\\\\', '\\', 'g')
            if evaluate
                let val = eval(val)
            endif
            let keyargs[key] = val
        else
            echom 'Unknown key: '. key .'='. val
        endif
    endfor
    return keyargs
endf



""" Command line {{{1

" :def: function! tlib#arg#Ex(arg, ?chars='%#! ')
" Escape some characters in a string.
"
" Use |fnamescape()| if available.
"
" EXAMPLES: >
"   exec 'edit '. tlib#arg#Ex('foo%#bar.txt')
function! tlib#arg#Ex(arg, ...) "{{{3
    if exists('*fnameescape') && a:0 == 0
        return fnameescape(a:arg)
    else
        " let chars = '%# \'
        let chars = '%#! '
        if a:0 >= 1
            let chars .= a:1
        endif
        return escape(a:arg, chars)
    endif
endf


autoload/tlib/fixes.vim	[[[1
14
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2013-02-22.
" @Revision:    3


function! tlib#fixes#Winpos() "{{{3
    if has('gui_win32')
        return 'winpos '. getwinposx() .' '. getwinposy()
    else
        return ''
    endif
endf

autoload/tlib/dir.vim	[[[1
100
" dir.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2013-09-25.
" @Revision:    0.0.37

if &cp || exists("loaded_tlib_dir_autoload")
    finish
endif
let loaded_tlib_dir_autoload = 1

" TLet g:tlib#dir#sep = '/'
TLet g:tlib#dir#sep = exists('+shellslash') && !&shellslash ? '\' : '/'


let s:dir_stack = []

" EXAMPLES: >
"   tlib#dir#CanonicName('foo/bar')
"   => 'foo/bar/'
function! tlib#dir#CanonicName(dirname) "{{{3
    if a:dirname !~ '[/\\]$'
        return a:dirname . g:tlib#dir#sep
    endif
    return a:dirname
endf


" EXAMPLES: >
"   tlib#dir#NativeName('foo/bar/')
"   On Windows:
"   => 'foo\bar\'
"   On Linux:
"   => 'foo/bar/'
function! tlib#dir#NativeName(dirname) "{{{3
    let sep = tlib#rx#EscapeReplace(g:tlib#dir#sep)
    let dirname = substitute(a:dirname, '[\/]', sep, 'g')
    return dirname
endf


" EXAMPLES: >
"   tlib#dir#PlainName('foo/bar/')
"   => 'foo/bar'
function! tlib#dir#PlainName(dirname) "{{{3
    let dirname = a:dirname
    while index(['/', '\'], dirname[-1 : -1]) != -1
        let dirname = dirname[0 : -2]
    endwh
    return dirname
    " return substitute(a:dirname, tlib#rx#Escape(g:tlib#dir#sep).'\+$', '', '')
endf


" Create a directory if it doesn't already exist.
function! tlib#dir#Ensure(dir) "{{{3
    if !isdirectory(a:dir)
        let dir = tlib#dir#PlainName(a:dir)
        return mkdir(dir, 'p')
    endif
    return 1
endf


" Return the first directory in &rtp.
function! tlib#dir#MyRuntime() "{{{3
    return get(split(&rtp, ','), 0)
endf


" :def: function! tlib#dir#CD(dir, ?locally=0) => CWD
function! tlib#dir#CD(dir, ...) "{{{3
    TVarArg ['locally', 0]
    let cmd = locally ? 'lcd ' : 'cd '
    " let cwd = getcwd()
    let cmd .= tlib#arg#Ex(a:dir)
    " TLogVAR a:dir, locally, cmd
    exec cmd
    " return cwd
    return getcwd()
endf


" :def: function! tlib#dir#Push(dir, ?locally=0) => CWD
function! tlib#dir#Push(dir, ...) "{{{3
    TVarArg ['locally', 0]
    call add(s:dir_stack, [getcwd(), locally])
    return tlib#dir#CD(a:dir, locally)
endf


" :def: function! tlib#dir#Pop() => CWD
function! tlib#dir#Pop() "{{{3
    let [dir, locally] = remove(s:dir_stack, -1)
    return tlib#dir#CD(dir, locally)
endf


autoload/tlib/hash.vim	[[[1
145
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    276


if !exists('g:tlib#hash#use_crc32')
    let g:tlib#hash#use_crc32 = ''   "{{{2
endif


if !exists('g:tlib#hash#use_adler32')
    let g:tlib#hash#use_adler32 = ''   "{{{2
endif


function! tlib#hash#CRC32B(chars) "{{{3
    if !empty(g:tlib#hash#use_crc32)
        let use = g:tlib#hash#use_crc32
    elseif has('ruby')
        let use = 'ruby'
    else
        let use = 'vim'
    endif
    if exists('*tlib#hash#CRC32B_'. use)
        return tlib#hash#CRC32B_{use}(a:chars)
    else
        throw "Unknown version of tlib#hash#CRC32B: ". use
    endif
endf


function! tlib#hash#CRC32B_ruby(chars) "{{{3
    if has('ruby')
        let rv = ''
        if !exists('s:loaded_ruby_zlib')
            ruby require 'zlib'
            let s:loaded_ruby_zlib = 1
        endif
        ruby VIM::command('let rv = "%08X"' % Zlib.crc32(VIM::evaluate("a:chars")))
        return rv
    else
        throw "tlib#hash#CRC32B_ruby not supported in this version of vim"
    endif
endf


function! tlib#hash#CRC32B_vim(chars) "{{{3
    if !exists('s:crc_table')
        let cfile = tlib#persistent#Filename('tlib', 'crc_table', 1)
        let s:crc_table = tlib#persistent#Value(cfile, 'tlib#hash#CreateCrcTable', 0)
    endif
    let xFFFF_FFFF = repeat([1], 32)
    let crc = tlib#bitwise#XOR([0], xFFFF_FFFF, 'bits')
    for char in split(a:chars, '\zs')
        let octet = char2nr(char)
        let r1 = tlib#bitwise#ShiftRight(crc, 8)
        let i0 = tlib#bitwise#AND(crc, xFFFF_FFFF, 'bits')
        let i1 = tlib#bitwise#XOR(i0, octet, 'bits')
        let i2 = tlib#bitwise#Bits2Num(tlib#bitwise#AND(i1, 0xff, 'bits'))
        let r2 = s:crc_table[i2]
        let crc = tlib#bitwise#XOR(r1, r2, 'bits')
    endfor
    let crc = tlib#bitwise#XOR(crc, xFFFF_FFFF, 'bits')
    let rv = tlib#bitwise#Bits2Num(crc, 16)
    if len(rv) < 8
        let rv = repeat('0', 8 - len(rv)) . rv
    endif
    return rv
endf


" :nodoc:
function! tlib#hash#CreateCrcTable() "{{{3
    let sum = 0.0
    for exponent in [0, 1, 2, 4, 5, 7, 8, 10, 11, 12, 16, 22, 23, 26, 32]
        let exp = tlib#bitwise#Bits2Num(repeat([0], 32 - exponent) + [1], 10.0)
        let sum += exp
    endfor
    let divisor = tlib#bitwise#Num2Bits(sum)
    let crc_table = []
    for octet in range(256)
        let remainder = tlib#bitwise#Num2Bits(octet)
        for i in range(8)
            if get(remainder, i) != 0
                let remainder = tlib#bitwise#XOR(remainder, tlib#bitwise#ShiftLeft(divisor, i), "bits")
            endif
        endfor
        let remainder = tlib#bitwise#ShiftRight(remainder, 8)
        call add(crc_table, remainder)
    endfor
    return crc_table
endf


function! tlib#hash#Adler32(chars) "{{{3
    if !empty(g:tlib#hash#use_adler32)
        let use = g:tlib#hash#use_adler32
    elseif exists('*or')
        let use = 'vim'
    else
        let use = 'tlib'
    endif
    if exists('*tlib#hash#Adler32_'. use)
        return tlib#hash#Adler32_{use}(a:chars)
    else
        throw "Unknown version of tlib#hash#Adler32_: ". use
    endif
endf


function! tlib#hash#Adler32_vim(chars) "{{{3
    if exists('*or')
        let mod_adler = 65521
        let a = 1
        let b = 0
        for index in range(len(a:chars))
            let c = char2nr(a:chars[index])
            let a = (a + c) % mod_adler
            let b = (b + a) % mod_adler
        endfor
        let bb = b * float2nr(pow(2, 16))
        let checksum = or(bb, a)
        " TLogVAR checksum, a, b, bb
        return printf("%08X", checksum)
    else
        throw "TLIB: Vim version doesn't support bitwise or()"
    endif
endf


function! tlib#hash#Adler32_tlib(chars) "{{{3
    let mod_adler = 65521
    let a = 1
    let b = 0
    for index in range(len(a:chars))
        let c = char2nr(a:chars[index])
        let a = (a + c) % mod_adler
        let b = (b + a) % mod_adler
    endfor
    let bb = tlib#bitwise#ShiftLeft(tlib#bitwise#Num2Bits(b), 16)
    let checksum = tlib#bitwise#OR(bb, a, "bits")
    return printf('%08s', tlib#bitwise#Bits2Num(checksum, 16))
endf


autoload/tlib/win.vim	[[[1
136
" win.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-08-24.
" @Last Change: 2010-12-04.
" @Revision:    0.0.54

if &cp || exists("loaded_tlib_win_autoload")
    finish
endif
let loaded_tlib_win_autoload = 1


" Return vim code to jump back to the original window.
function! tlib#win#Set(winnr) "{{{3
    if a:winnr > 0
        " TLogVAR a:winnr
        " TLogDBG winnr()
        " TLogDBG string(tlib#win#List())
        if winnr() != a:winnr && winbufnr(a:winnr) != -1
            let rv = winnr().'wincmd w'
            exec a:winnr .'wincmd w'
            " TLogVAR rv
            " TLogDBG string(tlib#win#List())
            return rv
        endif
    endif
    return ''
endf
 

" :def: function! tlib#win#GetLayout(?save_view=0)
function! tlib#win#GetLayout(...) "{{{3
    TVarArg ['save_view', 0]
    let views = {}
    if save_view
        let winnr = winnr()
        windo let views[winnr()] = winsaveview()
        " for w in range(1, winnr('$'))
        "     call tlib#win#Set(w)
        "     let views[w] = winsaveview()
        " endfor
        call tlib#win#Set(winnr)
    endif
    return {'winnr': winnr('$'), 'winrestcmd': winrestcmd(), 'views': views, 'cmdheight': &cmdheight, 'guioptions': &guioptions, 'tabpagenr': tabpagenr()}
endf


function! tlib#win#SetLayout(layout) "{{{3
    if a:layout.tabpagenr == tabpagenr() && a:layout.winnr == winnr('$')
        " TLogVAR a:layout.winrestcmd
        " TLogDBG string(tlib#win#List())
        exec a:layout.winrestcmd
        if !empty(a:layout.views)
            let winnr = winnr()
            " TLogVAR winnr
            for [w, v] in items(a:layout.views)
                " TLogVAR w, v
                call tlib#win#Set(w)
                call winrestview(v)
            endfor
            call tlib#win#Set(winnr)
        endif
        if a:layout.cmdheight != &cmdheight
            let &cmdheight = a:layout.cmdheight
        endif
        " TLogDBG string(tlib#win#List())
        return 1
    endif
    return 0
endf


function! tlib#win#List() "{{{3
    let wl = {}
    for wn in range(1, winnr('$'))
        let wl[wn] = bufname(winbufnr(wn))
    endfor
    return wl
endf


" " :def: function! tlib#win#GetLayout1(?save_view=0)
" " Contrary to |tlib#win#GetLayout|, this version doesn't use 
" " |winrestcmd()|. It can also save windows views.
" function! tlib#win#GetLayout1(...) "{{{3
"     TVarArg ['save_view', 0]
"     let winnr = winnr()
"     let acc = {}
"     for w in range(1, winnr('$'))
"         let def = {'h': winheight(w), 'w': winwidth(w)}
"         if save_view
"             call tlib#win#Set(w)
"             let def.view = winsaveview()
"         endif
"         let acc[w] = def
"     endfor
"     call tlib#win#Set(winnr)
"     return acc
" endf
" 
" 
" " Reset layout from the value of |tlib#win#GetLayout1|.
" function! tlib#win#SetLayout1(layout) "{{{3
"     if len(a:layout) != winnr('$')
"         return 0
"     endif
"     let winnr = winnr()
"     for [w, def] in items(a:layout)
"         if tlib#win#Set(w)
"             exec 'resize '. def.h
"             exec 'vertical resize '. def.w
"             if has_key(def, 'view')
"                 call winrestview(def.view)
"             endif
"         else
"             break
"         endif
"     endfor
"     call tlib#win#Set(winnr)
"     return 1
" endf


function! tlib#win#Width(wnr) "{{{3
    return winwidth(a:wnr) - &fdc
endf


function! tlib#win#WinDo(ex) "{{{3
    let w = winnr()
    exec 'windo '. a:ex
    exec w .'wincmd w'
endf

autoload/tlib/comments.vim	[[[1
57
" comments.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-11-15.
" @Last Change: 2009-02-15.
" @Revision:    0.0.24

if &cp || exists("loaded_tlib_comments_autoload")
    finish
endif
let loaded_tlib_comments_autoload = 1
let s:save_cpo = &cpo
set cpo&vim


" function! tlib#comments#Comments(?rx='')
function! tlib#comments#Comments(...)
    TVarArg ['rx', '']
    let comments = {}
    let co = &comments
    while !empty(co)
        " TLogVAR co
        let [m_0, m_key, m_val, m_val1, co0, co; rest] = matchlist(co, '^\([^:]*\):\(\(\\.\|[^,]*\)\+\)\(,\(.*\)$\|$\)')
        " TLogVAR m_key, m_val, co
        if empty(m_key)
            let m_key = ':'
        endif
        if empty(rx) || m_key =~ rx
            let comments[m_key] = m_val
        endif
    endwh
    return comments
endf


" function! tlib#comments#PartitionLine(line) "{{{3
"     if !empty(&commentstring)
"         let cs = '^\(\s*\)\('. printf(tlib#rx#Escape(&commentstring), '\)\(.\{-}\)\(') .'\)\(.*\)$'
"         let ml = matchlist(a:line, cs)
"     else
"         let ml = []
"     endif
"     if !empty(ml)
"         let [m_0, pre, open, line, close, post; rest] = ml
"     else
"         let [m_0, pre, line; rest] = matchstr(a:line, '^\(\s*\)\(.*\)$')
"         for [key, val] in tlib#comments#Comments()
"             if +++
"         endfor
"     endif
"     return {'pre': pre, 'open': open, 'line': line, 'close': close, 'post': post}
" endf


let &cpo = s:save_cpo
unlet s:save_cpo
autoload/tlib/grep.vim	[[[1
38
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2013-10-16.
" @Revision:    31


function! tlib#grep#Do(cmd, rx, files) "{{{3
    " TLogVAR a:cmd, a:rx, a:files
    let files = join(map(copy(a:files), 'tlib#arg#Ex(v:val, "")'), ' ')
    let rx = '/'. escape(a:rx, '/') .'/j'
    " TLogVAR rx, files
    silent exec a:cmd rx files
endf


function! tlib#grep#LocList(rx, files) "{{{3
    return tlib#grep#Do('noautocmd lvimgrep', a:rx, a:files)
endf


function! tlib#grep#QuickFixList(rx, files) "{{{3
    return tlib#grep#Do('noautocmd vimgrep', a:rx, a:files)
endf


function! tlib#grep#List(rx, files) "{{{3
    call setqflist([])
    call tlib#grep#Do('noautocmd vimgrepadd', a:rx, a:files)
    let qfl = getqflist()
    " TLogVAR qfl
    " try
        silent! colder
    " catch
    "     call setqflist([], 'r')
    " endtry
    return qfl
endf

autoload/tlib/Test.vim	[[[1
27
" Test.vim -- A test class
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-05-01.
" @Last Change: 2010-09-05.
" @Revision:    0.1.10

" :enddoc:

if &cp || exists("loaded_tlib_Test_autoload")
    finish
endif
let loaded_tlib_Test_autoload = 1


let s:prototype = tlib#Object#New({'_class': ['Test']}) "{{{2
function! tlib#Test#New(...) "{{{3
    let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
    return object
endf


function! s:prototype.Dummy() dict "{{{3
    return 'Test.vim'
endf

autoload/tlib/Filter_cnf.vim	[[[1
173
" Filter_cnf.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-11-25.
" @Last Change: 2014-01-23.
" @Revision:    0.0.108

let s:prototype = tlib#Object#New({'_class': ['Filter_cnf'], 'name': 'cnf'}) "{{{2
let s:prototype.highlight = g:tlib#input#higroup

" The search pattern for |tlib#input#List()| is in conjunctive normal 
" form: (P1 OR P2 ...) AND (P3 OR P4 ...) ...
" The pattern is a '/\V' very no-'/magic' regexp pattern.
"
" Pressing <space> joins two patterns with AND.
" Pressing | joins two patterns with OR.
" I.e. In order to get "lala AND (foo OR bar)", you type 
" "lala foo|bar".
"
" This is also the base class for other filters.
function! tlib#Filter_cnf#New(...) "{{{3
    let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
    return object
endf


" :nodoc:
function! s:prototype.Init(world) dict "{{{3
endf


" :nodoc:
function! s:prototype.Help(world) dict "{{{3
    call a:world.PushHelp(
                \ printf('"%s", "%s", "%sWORD"', g:tlib#input#and, g:tlib#input#or, g:tlib#input#not),
                \ 'AND, OR, NOT')
endf


" :nodoc:
function! s:prototype.AssessName(world, name) dict "{{{3
    let xa  = 0
    let prefix = self.FilterRxPrefix()
    for flt in a:world.filter_pos
        " let flt = prefix . a:world.GetRx(fltl)
        " if flt =~# '\u' && a:name =~# flt
        "     let xa += 5
        " endif

        if a:name =~ '\^'. flt
            let xa += 4
        elseif a:name =~ '\<'. flt
            let xa += 3
        " elseif a:name =~ '[[:punct:][:space:][:digit:]]'. flt
        "     let xa += 2
        elseif a:name =~ '\A'. flt .'\|'. flt .'\A'
            let xa += 1
        endif

        " if a:name =~ '\^'. flt .'\|'. flt .'\$'
        "     let xa += 4
        " elseif a:name =~ '\<'. flt .'\|'. flt .'\>'
        "     let xa += 3
        " " elseif a:name =~ flt .'\>'
        " "     let xa += 2
        " elseif a:name =~ '\A'. flt .'\|'. flt .'\A'
        "     let xa += 1
        " endif
        " if flt[0] =~# '\u' && matchstr(a:name, '\V\.\ze'. flt) =~# '\U'
        "     let xa += 1
        " endif
        " if flt[0] =~# '\U' && matchstr(a:name, '\V\.\ze'. flt) =~# '\u'
        "     let xa += 1
        " endif
        " if flt[-1] =~# '\u' && matchstr(a:name, '\V'. flt .'\zs\.') =~# '\U'
        "     let xa += 1
        " endif
        " if flt[-1] =~# '\U' && matchstr(a:name, '\V'. flt .'\zs\.') =~# '\u'
        "     let xa += 1
        " endif
    endfor
    " TLogVAR a:name, xa
    return xa
endf


" :nodoc:
function! s:prototype.Match(world, text) dict "{{{3
    " TLogVAR a:text
    " let sc = &smartcase
    " let ic = &ignorecase
    " if &ignorecase
    "     set smartcase
    " endif
    " try
    if !empty(a:world.filter_neg)
        for rx in a:world.filter_neg
            " TLogVAR rx
            if a:text =~ rx
                return 0
            endif
        endfor
    endif
    if !empty(a:world.filter_pos)
        for rx in a:world.filter_pos
            " TLogVAR rx
            if a:text !~ rx
                return 0
            endif
        endfor
    endif
    " finally
    "     let &smartcase = sc
    "     let &ignorecase = ic
    " endtry
    return 1
endf


" :nodoc:
function! s:prototype.DisplayFilter(filter) dict "{{{3
    let filter1 = deepcopy(a:filter)
    call map(filter1, '"(". join(reverse(self.Pretty(v:val)), " OR ") .")"')
    return join(reverse(filter1), ' AND ')
endf


function! s:prototype.Pretty(filter) dict "{{{3
    " call map(a:filter, 'substitute(v:val, ''\\\.\\{-}'', ''=>'', ''g'')')
    call map(a:filter, 'self.CleanFilter(v:val)')
    return a:filter
endf


" :nodoc:
function! s:prototype.SetFrontFilter(world, pattern) dict "{{{3
    let a:world.filter[0] = reverse(split(a:pattern, '\s*|\s*')) + a:world.filter[0][1 : -1]
endf


" :nodoc:
function! s:prototype.PushFrontFilter(world, char) dict "{{{3
    let a:world.filter[0][0] .= nr2char(a:char)
endf


" :nodoc:
function! s:prototype.ReduceFrontFilter(world) dict "{{{3
    let filter = a:world.filter[0][0]
    " TLogVAR filter
    let str = matchstr(filter, '\(\\\(\.\\{-}\|[.?*+$^]\)\|\)$')
    if empty(str)
        let filter = filter[0 : -2]
    else
        let filter = strpart(filter, 0, len(filter) - len(str))
    endif
    " TLogVAR str, filter
    let a:world.filter[0][0] = filter
endf


" :nodoc:
function! s:prototype.FilterRxPrefix() dict "{{{3
    return '\V'
endf


" :nodoc:
function! s:prototype.CleanFilter(filter) dict "{{{3
    return a:filter
endf

autoload/tlib/Object.vim	[[[1
163
" Object.vim -- Prototype objects?
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-05-01.
" @Last Change: 2011-03-10.
" @Revision:    0.1.126

" :filedoc:
" Provides a prototype plus some OO-like methods.


if &cp || exists("loaded_tlib_object_autoload")
    finish
endif
let loaded_tlib_object_autoload = 1

let s:id_counter = 0
let s:prototype  = {'_class': ['object'], '_super': [], '_id': 0} "{{{2

" :def: function! tlib#Object#New(?fields={})
" This function creates a prototype that provides some kind of 
" inheritance mechanism and a way to call parent/super methods.
"
" The usage demonstrated in the following example works best when every 
" class/prototype is defined in a file of its own.
"
" The reason for why there is a dedicated constructor function is that 
" this layout facilitates the use of templates and that methods are 
" hidden from the user. Other solutions are possible.
"
" EXAMPLES: >
"     let s:prototype = tlib#Object#New({
"                 \ '_class': ['FooBar'],
"                 \ 'foo': 1, 
"                 \ 'bar': 2, 
"                 \ })
"     " Constructor
"     function! FooBar(...)
"         let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
"         return object
"     endf
"     function! s:prototype.babble() {
"       echo "I think, therefore I am ". (self.foo * self.bar) ." months old."
"     }
"
" < This could now be used like this: >
"     let myfoo = FooBar({'foo': 3})
"     call myfoo.babble()
"     => I think, therefore I am 6 months old.
"     echo myfoo.IsA('FooBar')
"     => 1
"     echo myfoo.IsA('object')
"     => 1
"     echo myfoo.IsA('Foo')
"     => 0
"     echo myfoo.RespondTo('babble')
"     => 1
"     echo myfoo.RespondTo('speak')
"     => 0
function! tlib#Object#New(...) "{{{3
    return s:prototype.New(a:0 >= 1 ? a:1 : {})
endf


function! s:prototype.New(...) dict "{{{3
    let object = deepcopy(self)
    let s:id_counter += 1
    let object._id = s:id_counter
    if a:0 >= 1 && !empty(a:1)
        " call object.Extend(deepcopy(a:1))
        call object.Extend(a:1)
    endif
    return object
endf


function! s:prototype.Inherit(object) dict "{{{3
    let class = copy(self._class)
    " TLogVAR class
    let objid = self._id
    for c in get(a:object, '_class', [])
        " TLogVAR c
        if index(class, c) == -1
            call add(class, c)
        endif
    endfor
    call extend(self, a:object, 'keep')
    let self._class = class
    " TLogVAR self._class
    let self._id    = objid
    " let self._super = [super] + self._super
    call insert(self._super, a:object)
    return self
endf


function! s:prototype.Extend(dictionary) dict "{{{3
    let super = copy(self)
    let class = copy(self._class)
    " TLogVAR class
    let objid = self._id
    let thisclass = get(a:dictionary, '_class', [])
    for c in type(thisclass) == 3 ? thisclass : [thisclass]
        " TLogVAR c
        if index(class, c) == -1
            call add(class, c)
        endif
    endfor
    call extend(self, a:dictionary)
    let self._class = class
    " TLogVAR self._class
    let self._id    = objid
    " let self._super = [super] + self._super
    call insert(self._super, super)
    return self
endf


function! s:prototype.IsA(class) dict "{{{3
    return index(self._class, a:class) != -1
endf


function! s:prototype.IsRelated(object) dict "{{{3
    return len(filter(a:object._class, 'self.IsA(v:val)')) > 1
endf


function! s:prototype.RespondTo(name) dict "{{{3
    " return has_key(self, a:name) && type(self[a:name]) == 2
    return has_key(self, a:name)
endf


function! s:prototype.Super(method, arglist) dict "{{{3
    for o in self._super
        " TLogVAR o
        if o.RespondTo(a:method)
            " let self._tmp_method = o[a:method]
            " TLogVAR self._tmp_method
            " return call(self._tmp_method, a:arglist, self)
            return call(o[a:method], a:arglist, self)
        endif
    endfor
    echoerr 'tlib#Object: Does not respond to '. a:method .': '. string(self)
endf


function! tlib#Object#Methods(object, ...) "{{{3
    TVarArg ['pattern', '\d\+']
    let o = items(a:object)
    call filter(o, 'type(v:val[1]) == 2 && string(v:val[1]) =~ "^function(''\\d\\+'')"')
    let acc = {}
    for e in o
        let id = matchstr(string(e[1]), pattern)
        if !empty(id)
            let acc[id] = e[0]
        endif
    endfor
    return acc
endf

autoload/tlib/buffer.vim	[[[1
400
" buffer.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2013-09-25.
" @Revision:    0.0.352


" Where to display the line when using |tlib#buffer#ViewLine|.
" For possible values for position see |scroll-cursor|.
TLet g:tlib_viewline_position = 'zz'


let s:bmru = []


function! tlib#buffer#EnableMRU() "{{{3
    call tlib#autocmdgroup#Init()
    autocmd TLib BufEnter * call s:BMRU_Push(bufnr('%'))
endf


function! tlib#buffer#DisableMRU() "{{{3
    call tlib#autocmdgroup#Init()
    autocmd! TLib BufEnter
endf


function! s:BMRU_Push(bnr) "{{{3
    let i = index(s:bmru, a:bnr)
    if i >= 0
        call remove(s:bmru, i)
    endif
    call insert(s:bmru, a:bnr)
endf


function! s:CompareBuffernameByBasename(a, b) "{{{3
    let rx = '"\zs.\{-}\ze" \+\S\+ \+\d\+$'
    let an = matchstr(a:a, rx)
    let an = fnamemodify(an, ':t')
    let bn = matchstr(a:b, rx)
    let bn = fnamemodify(bn, ':t')
    let rv = an == bn ? 0 : an > bn ? 1 : -1
    return rv
endf


function! s:CompareBufferNrByMRU(a, b) "{{{3
    let an = matchstr(a:a, '\s*\zs\d\+\ze')
    let bn = matchstr(a:b, '\s*\zs\d\+\ze')
    let ai = index(s:bmru, 0 + an)
    if ai == -1
        return 1
    else
        let bi = index(s:bmru, 0 + bn)
        if bi == -1
            return -1
        else
            return ai == bi ? 0 : ai > bi ? 1 : -1
        endif
    endif
endf


" Set the buffer to buffer and return a command as string that can be 
" evaluated by |:execute| in order to restore the original view.
function! tlib#buffer#Set(buffer) "{{{3
    let lazyredraw = &lazyredraw
    set lazyredraw
    try
        let cb = bufnr('%')
        let sn = bufnr(a:buffer)
        if sn != cb
            let ws = bufwinnr(sn)
            if ws != -1
                let wb = bufwinnr('%')
                exec ws.'wincmd w'
                return wb.'wincmd w'
            else
                silent exec 'sbuffer! '. sn
                return 'wincmd c'
            endif
        else
            return ''
        endif
    finally
        let &lazyredraw = lazyredraw
    endtry
endf


" :def: function! tlib#buffer#Eval(buffer, code)
" Evaluate CODE in BUFFER.
"
" EXAMPLES: >
"   call tlib#buffer#Eval('foo.txt', 'echo b:bar')
function! tlib#buffer#Eval(buffer, code) "{{{3
    " let cb = bufnr('%')
    " let wb = bufwinnr('%')
    " " TLogVAR cb
    " let sn = bufnr(a:buffer)
    " let sb = sn != cb
    let lazyredraw = &lazyredraw
    set lazyredraw
    let restore = tlib#buffer#Set(a:buffer)
    try
        exec a:code
        " if sb
        "     let ws = bufwinnr(sn)
        "     if ws != -1
        "         try
        "             exec ws.'wincmd w'
        "             exec a:code
        "         finally
        "             exec wb.'wincmd w'
        "         endtry
        "     else
        "         try
        "             silent exec 'sbuffer! '. sn
        "             exec a:code
        "         finally
        "             wincmd c
        "         endtry
        "     endif
        " else
        "     exec a:code
        " endif
    finally
        exec restore
        let &lazyredraw = lazyredraw
    endtry
endf


" :def: function! tlib#buffer#GetList(?show_hidden=0, ?show_number=0, " ?order='bufnr')
" Possible values for the "order" argument:
"   bufnr    :: Default behaviour
"   mru      :: Sort buffers according to most recent use
"   basename :: Sort by the file's basename (last component)
"
" NOTE: MRU order works on second invocation only. If you want to always 
" use MRU order, call tlib#buffer#EnableMRU() in your ~/.vimrc file.
function! tlib#buffer#GetList(...)
    TVarArg ['show_hidden', 0], ['show_number', 0], ['order', '']
    " TLogVAR show_hidden, show_number, order
    let ls_bang = show_hidden ? '!' : ''
    redir => bfs
    exec 'silent ls'. ls_bang
    redir END
    let buffer_list = split(bfs, '\n')
    if order == 'mru'
        if empty(s:bmru)
            call tlib#buffer#EnableMRU()
            echom 'tlib: Installed Buffer MRU logger; disable with: call tlib#buffer#DisableMRU()'
        else
            call sort(buffer_list, function('s:CompareBufferNrByMRU'))
        endif
    elseif order == 'basename'
        call sort(buffer_list, function('s:CompareBuffernameByBasename'))
    endif
    let buffer_nr = map(copy(buffer_list), 'matchstr(v:val, ''\s*\zs\d\+\ze'')')
    " TLogVAR buffer_list, buffer_nr
    if show_number
        call map(buffer_list, 'matchstr(v:val, ''^\s*\d\+.\{-}\ze\s\+\S\+ \d\+\s*$'')')
    else
        call map(buffer_list, 'matchstr(v:val, ''^\s*\d\+\zs.\{-}\ze\s\+\S\+ \d\+\s*$'')')
    endif
    " TLogVAR buffer_list
    " call map(buffer_list, 'matchstr(v:val, ''^.\{-}\ze\s\+line \d\+\s*$'')')
    " TLogVAR buffer_list
    call map(buffer_list, 'matchstr(v:val, ''^[^"]\+''). printf("%-20s   %s", fnamemodify(matchstr(v:val, ''"\zs.\{-}\ze"$''), ":t"), fnamemodify(matchstr(v:val, ''"\zs.\{-}\ze"$''), ":h"))')
    " TLogVAR buffer_list
    return [buffer_nr, buffer_list]
endf


" :def: function! tlib#buffer#ViewLine(line, ?position='z')
" line is either a number or a string that begins with a number.
" For possible values for position see |scroll-cursor|.
" See also |g:tlib_viewline_position|.
function! tlib#buffer#ViewLine(line, ...) "{{{3
    if a:line
        TVarArg 'pos'
        let ln = matchstr(a:line, '^\d\+')
        let lt = matchstr(a:line, '^\d\+: \zs.*')
        " TLogVAR pos, ln, lt
        exec ln
        if empty(pos)
            let pos = tlib#var#Get('tlib_viewline_position', 'wbg')
        endif
        " TLogVAR pos
        if !empty(pos)
            exec 'norm! '. pos
        endif
        call tlib#buffer#HighlightLine(ln)
        " let @/ = '\%'. ln .'l.*'
    endif
endf


function! s:UndoHighlightLine() "{{{3
    3match none
    autocmd! TLib CursorMoved,CursorMovedI <buffer>
    autocmd! TLib CursorHold,CursorHoldI <buffer>
    autocmd! TLib InsertEnter,InsertChange,InsertLeave <buffer>
    autocmd! TLib BufLeave,BufWinLeave,WinLeave,BufHidden <buffer>
endf


function! tlib#buffer#HighlightLine(...) "{{{3
    TVarArg ['line', line('.')]
    " exec '3match MatchParen /^\%'. a:line .'l.*/'
    exec '3match Search /^\%'. line .'l.*/'
    call tlib#autocmdgroup#Init()
    exec 'autocmd TLib CursorMoved,CursorMovedI <buffer> if line(".") != '. line .' | call s:UndoHighlightLine() | endif'
    autocmd TLib CursorHold,CursorHoldI <buffer> call s:UndoHighlightLine()
    autocmd TLib InsertEnter <buffer> call s:UndoHighlightLine()
    " autocmd TLib BufLeave,BufWinLeave,WinLeave,BufHidden <buffer> call s:UndoHighlightLine()
endf


" Delete the lines in the current buffer. Wrapper for |:delete|.
function! tlib#buffer#DeleteRange(line1, line2) "{{{3
    let r = @t
    try
        exec a:line1.','.a:line2.'delete t'
    finally
        let @t = r
    endtry
endf


" Replace a range of lines.
function! tlib#buffer#ReplaceRange(line1, line2, lines)
    call tlib#buffer#DeleteRange(a:line1, a:line2)
    call append(a:line1 - 1, a:lines)
endf


" Initialize some scratch area at the bottom of the current buffer.
function! tlib#buffer#ScratchStart() "{{{3
    norm! Go
    let b:tlib_inbuffer_scratch = line('$')
    return b:tlib_inbuffer_scratch
endf


" Remove the in-buffer scratch area.
function! tlib#buffer#ScratchEnd() "{{{3
    if !exists('b:tlib_inbuffer_scratch')
        echoerr 'tlib: In-buffer scratch not initalized'
    endif
    call tlib#buffer#DeleteRange(b:tlib_inbuffer_scratch, line('$'))
    unlet b:tlib_inbuffer_scratch
endf


" Run exec on all buffers via bufdo and return to the original buffer.
function! tlib#buffer#BufDo(exec) "{{{3
    let bn = bufnr('%')
    exec 'bufdo '. a:exec
    exec 'buffer! '. bn
endf


" :def: function! tlib#buffer#InsertText(text, keyargs)
" Keyargs:
"   'shift': 0|N
"   'col': col('.')|N
"   'lineno': line('.')|N
"   'indent': 0|1
"   'pos': 'e'|'s' ... Where to locate the cursor (somewhat like s and e in {offset})
" Insert text (a string) in the buffer.
function! tlib#buffer#InsertText(text, ...) "{{{3
    TVarArg ['keyargs', {}]
    " TLogVAR a:text, keyargs
    TKeyArg keyargs, ['shift', 0], ['col', col('.')], ['lineno', line('.')], ['pos', 'e'],
                \ ['indent', 0]
    " TLogVAR shift, col, lineno, pos, indent
    let grow = 0
    let post_del_last_line = line('$') == 1
    let line = getline(lineno)
    if col + shift > 0
        let pre  = line[0 : (col - 1 + shift)]
        let post = line[(col + shift): -1]
    else
        let pre  = ''
        let post = line
    endif
    " TLogVAR lineno, line, pre, post
    let text0 = pre . a:text . post
    let text  = split(text0, '\n', 1)
    " TLogVAR text
    let icol = len(pre)
    " exec 'norm! '. lineno .'G'
    call cursor(lineno, col)
    if indent && col > 1
		if &fo =~# '[or]'
            " FIXME: Is the simple version sufficient?
            " VERSION 1
			" " This doesn't work because it's not guaranteed that the 
			" " cursor is set.
			" let cline = getline('.')
			" norm! a
			" "norm! o
			" " TAssertExec redraw | sleep 3
			" let idt = strpart(getline('.'), 0, col('.') + shift)
			" " TLogVAR idt
			" let idtl = len(idt)
			" -1,.delete
			" " TAssertExec redraw | sleep 3
			" call append(lineno - 1, cline)
			" call cursor(lineno, col)
			" " TAssertExec redraw | sleep 3
			" if idtl == 0 && icol != 0
			" 	let idt = matchstr(pre, '^\s\+')
			" 	let idtl = len(idt)
			" endif
            " VERSION 2
            let idt = matchstr(pre, '^\s\+')
            let idtl = len(idt)
		else
			let [m_0, idt, iline; rest] = matchlist(pre, '^\(\s*\)\(.*\)$')
			let idtl = len(idt)
		endif
		if idtl < icol
			let idt .= repeat(' ', icol - idtl)
		endif
        " TLogVAR idt
        let idtl1 = len(idt)
        for i in range(1, len(text) - 1)
            let text[i] = idt . text[i]
            let grow += idtl1
        endfor
    endif
    " TLogVAR text
    " exec 'norm! '. lineno .'Gdd'
    call tlib#normal#WithRegister('"tdd', 't')
    call append(lineno - 1, text)
    if post_del_last_line
        call tlib#buffer#KeepCursorPosition('$delete')
    endif
    let tlen = len(text)
    let posshift = matchstr(pos, '\d\+')
    " TLogVAR pos
    if pos =~ '^e'
        exec lineno + tlen - 1
        exec 'norm! 0'. (len(text[-1]) - len(post) + posshift - 1) .'l'
    elseif pos =~ '^s'
        " TLogVAR lineno, pre, posshift
        exec lineno
        exec 'norm! '. len(pre) .'|'
        if !empty(posshift)
            exec 'norm! '. posshift .'h'
        endif
    endif
    " TLogDBG getline(lineno)
    " TLogDBG string(getline(1, '$'))
    return grow
endf


function! tlib#buffer#InsertText0(text, ...) "{{{3
    TVarArg ['keyargs', {}]
    let mode = get(keyargs, 'mode', 'i')
    " TLogVAR mode
    if !has_key(keyargs, 'shift')
        let col = col('.')
        " if mode =~ 'i'
        "     let col += 1
        " endif
        let keyargs.shift = col >= col('$') ? 0 : -1
        " let keyargs.shift = col('.') >= col('$') ? 0 : -1
        " TLogVAR col
        " TLogDBG col('.') .'-'. col('$') .': '. string(getline('.'))
    endif
    " TLogVAR keyargs.shift
    return tlib#buffer#InsertText(a:text, keyargs)
endf


function! tlib#buffer#CurrentByte() "{{{3
    return line2byte(line('.')) + col('.')
endf


" Evaluate cmd while maintaining the cursor position and jump registers.
function! tlib#buffer#KeepCursorPosition(cmd) "{{{3
    " let pos = getpos('.')
    let view = winsaveview()
    try
        keepjumps exec a:cmd
    finally
        " call setpos('.', pos)
        call winrestview(view)
    endtry
endf

autoload/tlib/hook.vim	[[[1
33
" hook.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-08-21.
" @Last Change: 2009-02-15.
" @Revision:    0.0.10

if &cp || exists("loaded_tlib_hook_autoload")
    finish
endif
let loaded_tlib_hook_autoload = 1


" :def: function! tlib#hook#Run(hook, ?dict={})
" Execute dict[hook], w:{hook}, b:{hook}, or g:{hook} if existent.
function! tlib#hook#Run(hook, ...) "{{{3
    TVarArg ['dict', {}]
    if has_key(dict, a:hook)
        let hook = dict[a:hook]
    else
        let hook = tlib#var#Get(a:hook, 'wbg')
    endif
    if empty(hook)
        return 0
    else
        let world = dict
        exec hook
        return 1
    endif
endf


autoload/tlib/string.vim	[[[1
156
" string.vim
" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2009-02-15.
" @Revision:    0.0.110

if &cp || exists("loaded_tlib_string_autoload")
    finish
endif
let loaded_tlib_string_autoload = 1


" :def: function! tlib#string#RemoveBackslashes(text, ?chars=' ')
" Remove backslashes from text (but only in front of the characters in 
" chars).
function! tlib#string#RemoveBackslashes(text, ...) "{{{3
    exec tlib#arg#Get(1, 'chars', ' ')
    " TLogVAR chars
    let rv = substitute(a:text, '\\\(['. chars .']\)', '\1', 'g')
    return rv
endf


function! tlib#string#Chomp(string) "{{{3
    return substitute(a:string, '[[:cntrl:][:space:]]*$', '', '')
endf


function! tlib#string#Format(template, dict) "{{{3
    let parts = split(a:template, '\ze%\({.\{-}}\|.\)')
    let out = []
    for part in parts
        let ml   = matchlist(part, '^%\({\(.\{-}\)}\|\(.\)\)\(.*\)$')
        if empty(ml)
            let rest = part
        else
            let var  = empty(ml[2]) ? ml[3] : ml[2]
            let rest = ml[4]
            if has_key(a:dict, var)
                call add(out, a:dict[var])
            elseif var == '%%'
                call add(out, '%')
            else
                call add(out, ml[1])
            endif
        endif
        call add(out, rest)
    endfor
    return join(out, '')
endf


" This function deviates from |printf()| in certain ways.
" Additional items:
"     %{rx}      ... insert escaped regexp
"     %{fuzzyrx} ... insert typo-tolerant regexp
function! tlib#string#Printf1(format, string) "{{{3
    let s = split(a:format, '%.\zs')
    " TLogVAR s
    return join(map(s, 's:PrintFormat(v:val, a:string)'), '')
endf

function! s:PrintFormat(format, string) "{{{3
    let cut = match(a:format, '%\({.\{-}}\|.\)$')
    if cut == -1
        return a:format
    else
        let head = cut > 0 ? a:format[0 : cut - 1] : ''
        let tail = a:format[cut : -1]
        " TLogVAR head, tail
        if tail == '%{fuzzyrx}'
            let frx = []
            for i in range(len(a:string))
                if i > 0
                    let pb = i - 1
                else
                    let pb = 0
                endif
                let slice = tlib#rx#Escape(a:string[pb : i + 1])
                call add(frx, '['. slice .']')
                call add(frx, '.\?')
            endfor
            let tail = join(frx, '')
        elseif tail == '%{rx}'
            let tail = tlib#rx#Escape(a:string)
        elseif tail == '%%'
            let tail = '%'
        elseif tail == '%s'
            let tail = a:string
        endif
        " TLogVAR tail
        return head . tail
    endif
endf
" function! tlib#string#Printf1(format, string) "{{{3
"     let n = len(split(a:format, '%\@<!%s', 1)) - 1
"     let f = a:format
"     if f =~ '%\@<!%{fuzzyrx}'
"         let frx = []
"         for i in range(len(a:string))
"             if i > 0
"                 let pb = i - 1
"             else
"                 let pb = 0
"             endif
"             let slice = tlib#rx#Escape(a:string[pb : i + 1])
"             call add(frx, '['. slice .']')
"             call add(frx, '.\?')
"         endfor
"         let f = s:RewriteFormatString(f, '%{fuzzyrx}', join(frx, ''))
"     endif
"     if f =~ '%\@<!%{rx}'
"         let f = s:RewriteFormatString(f, '%{rx}', tlib#rx#Escape(a:string))
"     endif
"     if n == 0
"         return substitute(f, '%%', '%', 'g')
"     else
"         let a = repeat([a:string], n)
"         return call('printf', insert(a, f))
"     endif
" endf


function! s:RewriteFormatString(format, pattern, string) "{{{3
    let string = substitute(a:string, '%', '%%', 'g')
    return substitute(a:format, tlib#rx#Escape(a:pattern), escape(string, '\'), 'g')
endf


function! tlib#string#TrimLeft(string) "{{{3
    return substitute(a:string, '^[[:space:][:cntrl:]]\+', '', '')
endf


function! tlib#string#TrimRight(string) "{{{3
    return substitute(a:string, '[[:space:][:cntrl:]]\+$', '', '')
endf


function! tlib#string#Strip(string) "{{{3
    return tlib#string#TrimRight(tlib#string#TrimLeft(a:string))
endf


function! tlib#string#Count(string, rx) "{{{3
    let s:count = 0
    call substitute(a:string, a:rx, '\=s:CountHelper()', 'g')
    return s:count
endf

function! s:CountHelper() "{{{3
    let s:count += 1
endf

