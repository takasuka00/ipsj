@echo off
set resPath=%~f1\src
set mainResPath=%resPath%\main
set bibResPath=%resPath%\references
set outputPath=%~f1\out
set mainOutPath=%outputPath%\main

rem bibを出力用のパスにコピー, auxが参照できるようにする
call copy %bibResPath%.bib %outputPath%\references.bib
rem aux作成
call platex -output-directory=%outputPath% -synctex=1 -jobname=main -kanji=utf8 -guess-input-enc %mainResPath%
rem auxを参照してpbibtexがbbl(blg)を作成
cd /d %outputPath%
call pbibtex main -kanji=utf8
cd /d %resPath%
rem auxとbblを紐付け
call platex -output-directory=%outputPath% -synctex=1 -jobname=main -kanji=utf8 -guess-input-enc %mainResPath%
rem 上記の紐付けを参照にしてpdf作成
call platex -output-directory=%outputPath% -synctex=1 -jobname=main -kanji=utf8 -guess-input-enc %mainResPath%
rem dviからpdfを生成
cd /d %outputPath%
call dvipdfmx main.dvi
cd /d %resPath%
rem コピーしたbibは邪魔なので消す
call del %outputPath%\references.bib
rem pdfを開く
start "" "%outputPath%\main.pdf"
exit 0
