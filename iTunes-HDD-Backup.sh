#!/usr/bin/env zsh

# bashを意識して書いたスクリプトだけれど，zshでも変更なく動く模様。
# bashはcolorcodeを無視しちゃうけど，zshはちゃんとcolorcodeをrespectしてくれる。 (macOSデフォルトについてくるbashとzshの話)

DATE=$(date +%Y-%m-%d)
DESTDIR=/Volumes/USB-HDD-3TB/iTunes
TAR=$(which gtar || which tar) # assuming we are using GNU tar

echo "Closing iTunes..."
pkill iTunes

pushd $HOME
echo "Moved to $PWD"
# create tar archive
mkdir -p $DESTDIR/tar $DESTDIR/index
echo "\e[1;32mCreating tar...\e[1;30m"
${TAR} cf - iTunes/ | pv > $DESTDIR/tar/iTunesLibrary-$DATE.tar
pushd $DESTDIR/tar # current directory is $DESTDIR/tar
echo "\e[1;32mCreating symlink...\e[1;30m"
unlink iTunesLibrary-current.tar; ln -s iTunesLibrary-$DATE.tar iTunesLibrary-current.tar
popd # current directory is $DESTDIR/tar => $HOME
pushd $DESTDIR
unlink iTunesLibrary-current.tar; ln -s tar/iTunesLibrary-current.tar iTunesLibrary-current.tar
popd
pushd $DESTDIR/index # current directory is $DESTDIR/index
echo "\e[1;32mCreating index...\e[1;30m"
${TAR} tf $DESTDIR/tar/iTunesLibrary-$DATE.tar > $DESTDIR/index/iTunesLibrary-$DATE-index.txt
popd # current directory is $HOME
popd # back to previous directory

## TODO:
# HDDの使用容量が一定のサイズに達したときに，内容が重複しているアーカイブを自動的に削除する
