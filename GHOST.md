# GHOST.md

「SHIORIES」（`install.txt` の名前は「萌えSHIORI～ず」）に固有の情報です。AI エージェントは、作業の前に読みます。
作者が自由に書き換えるファイルです。

## このゴーストについて

- 伺か（ukagaka）のゴースト。SHIORI たちが擬人化して、ゴーストを動かす舞台裏を語る。
- 2006 年に華和梨（KAWARI）8 とミドルウェア OpenKEEPS で作られた。**YAYA 6 コア版として、辞書を全面的に組み直した**（シェルはそのまま）。
- 配布元: http://ms.shillest.net/ 、リポジトリ: https://github.com/YAYA-shiori/shiories
- ネットワーク更新の URL（`On_homeurl`）は `https://yaya-shiori.github.io/shiories/`（GitHub Pages）。`ghost/master/dic/normal/yaya_homeurl.dic` と `ghost/master/dic/emerg/yaya_homeurl.dic` の 2 か所に書く。この URL の直下に `updates2.dau`、`delete.txt`、nar を GitHub Actions でデプロイする（`updates2.dau` と `updates.txt` は `.gitignore` で除外してある。`ghost/master/dic/system` は submodule で、GitHub の raw からは配れないため）。
- 配布物は `.github/workflows/auto_deploy.yml` が作る。辞書チェック（`auto check`）が通った `main` / `master` の push ごとに、`.github/scripts/build-site.ps1` が nar（`.narignore` で除外）と更新ファイル一式（`.updateignore` で除外）を作って Pages に出す。手元でも `pwsh ./.github/scripts/build-site.ps1 -OutDir site`（`-ListOnly` で一覧だけ）で同じものが作れる。リポジトリの Settings > Pages > Source は「GitHub Actions」にしておく。
- 同梱バルーン `Hukidasi7_splashstar/` は nar には入れるが、ゴーストの更新ファイルには入れない（`.updateignore`）。バルーンには単独の `updates2.dau` と `updates.txt` を作り、`https://yaya-shiori.github.io/shiories/Hukidasi7_splashstar/` に出す。`Hukidasi7_splashstar/descript.txt` の `homeurl` がそこを指す。どのバルーンを対象にするかは、`install.txt` の `balloon.directory`（と `balloon.source.directory`）から読む。
- 旧版の利用者は、旧版が報告する `http://ms.shillest.net/ghost/shiories/` から更新する。この版を届けるには、そちらにも公開する必要がある。
- 作った人（`readme.txt`）: シェル ＝ ボトル猫 / ゴースト ＝ さとー（華和梨担当）、水無月藍（文・里々担当）、ぽな（雑用）

## ライセンス

- ゴースト（辞書）の著作権者は「整備班」。ライセンスは クリエイティブ・コモンズ 表示 2.5（`readme.txt`）。
- シェル `shell/master/` の作者はボトル猫氏（`shell/master/descript.txt`）。**画像は編集しない。**
- 同梱バルーン `Hukidasi7_splashstar/` の原作者は、はっぷん氏（`readme_original.txt` は転載を「出来る限り不許可」としている）。このバルーンは改造して使う作風で、このゴーストの作者が改造を了承している。画像は編集してよい。

## キャラクターとサーフェス

4 人が同時に出る。**トークの頭では全員を初期状態にそろえる**（`\p[3]\s[-1]\p[2]\s[2000]\1\s[1000]\0\s[0]`）。

| スコープ | キャラクター | 人物像（既存のトークから） | 使えるサーフェス |
|---|---|---|---|
| `\0`（`\h`） | 華和梨 | SHIORI「華和梨」。長女で、眼鏡。しっかり者のツッコミ役だが、ばぐとら所長（デバッガ）に弱く、すぐ落ち込む。里々や文を「里々」「文ちゃん」と呼ぶ | 0 素 / 1 照れ / 2 驚き / 3 不安 / 4 落ち込み / 5 微笑み / 6 目閉じ / 7 怒り / 8 呆れ / 9 照れ怒り / 11 ちょっと照れ / 14 落ち込み涙 / 100 素2 / 101 照れ2 / 102 驚き2 / 103 不安2 / 104 ちょっと落ち込み / 105 笑い / 106 目閉じ2 / 108 呆れ2 / 111 髪触り照れ / 114 泣き笑い / 150 視線合わせ素 / 152 え？ / 153 考え中 / 155 照れ笑い / 158 ちょっと呆れ / 202 メガネメガネ / 208 もしもし？ |
| `\1`（`\u`） | 里々 | SHIORI「里々」。元気で無邪気な**男の子**（見た目は女の子）。「ボク」。自分の人気（シェア）が気になる | 1000 素 / 1001 照れ / 1002 驚き / 1003 不安 / 1004 落ち込み / 1005 微笑み / 1006 目閉じ / 1007 怒り / 1008 呆れ / 1009 照れ怒り / 1101 赤面 / 1105 幸せ / 1106 祈り / 1108 苦笑 / 1151 照れ困惑 / 1155 わはー / 1205 照れ幸せ |
| `\p[2]` | 文（あや） | SHIORI「文」（AYA）。無口でお茶好き。ぼそっと毒を吐く。「ふみ」と呼ぶと泣く。みかん箱（文箱）に隠れる | 2000 素 / 2001 照れ / 2002 驚き / 2003 不安 / 2004 落ち込み / 2005 微笑み / 2006 目閉じ / 2007 怒り / 2010 / 2050 お茶 / 2100 みかん箱 / 2101 うろたえ / 2106 祈り / 2150 受信中 |
| `\p[3]` | 里珠 | 「デスクトップの女王」。高笑いする縦ロール。重いと言われると怒る | 3000 素 / 3001 こけ / 3005 高笑い / 3009 照れ怒り |

- 消すときは `\s[-1]`。里珠は普段出ていない（トークの頭で `\p[3]\s[-1]`）。
- 華和梨の当たり判定（`surfaces.txt` の `collision`）は `Head`、`Face`、`Bust`。里々は `Head`、`Face`、`Bust`、`Crotch`。文は `Head`、`Face`、`Bust`、`Antenna`、`Jewel`、`Box`（みかん箱のとき）、`Nar`。
- 使うサーフェス番号は上の表にあるものだけ。`element*.png` は部品なので、トークでは指定しない。
- サーフェス 2009（文の照れ怒り）は、`surfaces.txt` に定義がない。使わない（元の辞書の台詞 1 件は 2007 に置き換えた）。

## 辞書の構成

- `ghost/master/yaya.txt` が `dic/normal` を読む。辞書エラーのときは `yaya_emerg.txt` が `dic/emerg` を読む（緊急モード）。
- `ghost/master/dic/system/` はシステム辞書（yaya-dic の submodule）。**編集しない。**
- 旧版（華和梨 + OpenKEEPS）の `kawarirc.kis`、`openkeeps/`、`template/`、`saori/` は無くなった。`delete.txt` で、ネットワーク更新のときに消す。
- `neta.txt` は作者のメモ（ネタ箇条書きと会話サンプル）。辞書には読み込まれない。
- `Hukidasi7_splashstar/` は同梱するバルーン「ふきだし７・すぷらしゅすたー」（Happen / 水無月藍）。`install.txt` の `balloon.directory` が指す。このゴースト向けに改造してある（下の「バルーン」）。
- 文字コードは UTF-8（BOM なし、LF）。**`shell/` だけは元の Shift_JIS・CRLF のまま**で、`.gitattributes` と `.editorconfig` で Git やエディタに変換させないようにしてある（`shell/master/descript.txt` と `surfacetable.txt`）。`readme.txt`、`neta.txt`、バルーンのテキストは UTF-8 に変換した（`charset,UTF-8` を明記）。

## バルーン

同梱バルーン `Hukidasi7_splashstar/` は、頭上に出す吹き出し（左向きだけ）に絞ってある。キャラクターごとにテーマ色を変えている。色は https://github.com/ukatech/ukatech.github.io の `DESIGN.md` と `site/assets/tokens.css`（ライトモード）から取った。バルーンには暗色の切り替えが無いので、ライトの値だけを使う。

| スコープ | 吹き出しの画像 | main（枠） | sub（内側の線） | アンカーとカーソル |
|---|---|---|---|---|
| `\0` 華和梨 | `balloons0.png` | `#1c1d21` | `#c4262e` | sub（`balloons0s.txt`） |
| `\1` 里々 | `balloonk0.png` | `#2f6b3f` | `#b48e3e` | main（`balloonk0s.txt`） |
| `\p[2]` 文（YAYA） | `balloonp2def0.png` | `#9b3f3a` | `#1c1d21` | main（`balloonp2def0s.txt`） |
| `\p[3]` 里珠（ゲスト） | `balloonp3def0.png` | `#5e616b` | `#8a8d96` | `descript.txt` の共通の色（`#2f6fd6`） |

- 地の色は、どの吹き出しも生成り（`#fafaf8`）。色は枠と、左右の内側の 2 本線（sub）だけに使う。文字は共通で墨色（`#1c1d21`）。
- 矢印（`arrows*` `arrowk*` `arrowp2def*` `arrowp3def*`）、SSTP のマーカー（`sstp_new*`）、オンライン表示（`onlines*` `onlinek*` `onlinep2def*` `onlinep3def*`）も、同じ組ごとの色にしてある。`arrow0/1`、`sstp.png`、`online0/1`、入力ボックス（`balloonc0-5.png`）は、組に属さない色（ゲストと同じ無彩色）。
- 入力ボックスは、元の `balloonc0.png` から「SEND FOR...」の文字を消し、真ん中の同じ行の帯（元の 17〜47 行目）を増減して高さを変えたうえで、左上にラベルを描いた（Consolas 13px、`#5e616b`。サイトの `--font-mono` に合わせた）。`balloonc0-4.png`（Send / Communicate / Teach / Input / Address Bar）は 400x57、`balloonc5.png`（Textarea、複数行入力）は 400x150。入力欄はラベルの下に置くので、位置は元のまま `descript.txt` の `communicatebox.*`（`y` は 21、高さは 20）で、`c5` だけ `balloonc5s.txt` で高さを 113 にしている。
- 元のオレンジのバルーンの色は、すべて R=255 で G だけが違う 1 本の階調（地 G=222、外枠 G=163、内側の線 G=185、影はその間）だった。そこで、画素の G の値に応じて、地・main・sub に対応させて塗り替えた。パレット形式の PNG のまま、透過色の緑（`#00ff00`）も残している。色を変えたいときは、この対応をもう一度かける。元のオレンジの画像は、コミット「バルーン Hukidasi7_splashstar の頭上バルーン向けに不要な定義を削除して最適化する」にある。
- `thumbnail.pnr`（メニューに出るロゴ）は元のまま。
- 本体用の SSTP マーカーの名前は、UKADOC に `sstp_new` と `sstp_news` の両方が出てくるので、どちらも置いてある。矢印、SSTP マーカー、オンライン表示が組ごとに切り替わることは、SSP では未確認（吹き出しの画像と、`balloons0s.txt` などによるアンカーの色の上書きは、SSP で確かめた）。

## イベントと辞書ファイルの対応

| ファイル（`ghost/master/dic/normal/`） | 主な中身 |
|---|---|
| `yaya_core.dic` | 変数の初期化（`OnSystemLoad.SHIORIES`）、起動・終了の記録（`BootStart` `MarkClosed`）、時間帯の判定（`GetTimeZone`） |
| `yaya_aitalk.dic` | ランダムトーク（`RandomTalkEx`）、チェイントーク、時報・起動時間・重なり（`OnMinuteChange`）、見切れ（`OnSecondChange`）、サーフェス復帰（`OnSurfaceRestore`） |
| `yaya_bootend.dic` | 初回起動 `OnFirstBoot`、起動 `OnBoot`（時間帯ごとに `Boot_*`）、終了 `OnClose`（`Close_*`） |
| `yaya_mouse.dic` | マウスへの反応。関数名は「種別＋スコープ番号＋当たり判定名」。撫で反応は段階式（`StrokeLimit*` `StrokeLoop*` `MouseMove*_<段階>`） |
| `yaya_menu.dic` | メニュー `OpenMenu` と、選択肢ごとの処理 `Menu_*`、ユーザー名の変更 |
| `yaya_change.dic` | ゴーストの切り替え。`OnGhostChanging_<相手の\0側の名前>` `OnGhostChanged_<…>`、無ければ `…Other` |
| `yaya_communicate.dic` | ユーザー・他のゴーストとの会話（`ReplyTo*` `TalkTo*`） |
| `yaya_etc.dic` | 汎用イベントトーク（インストール、更新、メール等）、最小化復帰、消滅指示、時計合わせ、ヘッドライン |
| `yaya_notify.dic` | カレンダー、「きのこ」「猫どりふ」、MATERIA、システムリソースの通知への反応 |
| `yaya_legacy.dic` | 元の OpenKEEPS のイベント名のまま移した反応。アプリケーション通知（`OnApplication*`）、`OnWebsiteUpdateNotify`、UD Sensor（`OnUdsUpdate`）、Winamp / iTunes（`OnMusicPlay` `OnMusicPlayEx`）、RSS（`OnRSS*`）、壁紙（`OnWallpaperChange`）、スケジュール投稿、電池残量。今の SSP が通知しないものも含む |
| `yaya_effect.dic` | 演出（`Shake` 振動、`Teleport` テレポート）と `ChangeGhostOrClose` |
| `yaya_string.dic` | ユーザー名、右クリックメニューのボタン名、お勧めサイト・ポータルサイト（`On_*`）、サイトが選ばれたときの反応 |
| `yaya_word.dic` | トーク中に `%(里々ゴースト)` のように埋め込む単語、`偽暗号` |
| `yaya_homeurl.dic` | ネットワーク更新の URL（`On_homeurl`） |
| `yaya_tmpl_util.dic` | テンプレートの内部処理（`AYATEMPLATE.*`）。必要なとき以外は触らない |

保存する変数（`yaya_variable.cfg`）: `username`、`aitalkinterval`、`intervalkeyword`（お喋り頻度の表示名）、`option_mikire` `option_kasanari` `option_shake`（オプション。1 が有効）、`boot_mutex` `last_close_sec` `ghost_boot_sec` `worktime` `unload_clean`（起動・終了の記録。`boot_mutex` が 1 のまま、しかも前回アンロードされていなければ、異常終了として起動時に「落ちた」トークをする）。

## トークの書き方

元の辞書（華和梨のマクロ）の約束を、そのままさくらスクリプトで書いている。

- 話し始める側のスコープと表情を最初に指定する。トークの頭は全員をそろえる（上の「キャラクターとサーフェス」）。
- 読点の後は `\w4`、句点・「？」「！」の後は `\w8`、「…」は `…\w8…\w8`。沈黙は `…\w8…\w8`。
- 同じ話し手の中の改行は `\n`。
- **話し手を交代するときは、`\n` の直後に `\n[half]` を入れて**から、スコープのタグを書く。`\n\n[half]\1\s[1005]…`。
- 全員が同時に反応するときは `\_s[0,1,2]…\_s`（同時発話）。
- ユーザーは `%(username)` で呼ぶ。トークの最後は `\e`。終了のトーク（`Close_*`）は `\e` を付けない（`OnClose` が `\-` を足す）。
- 振動は `%(Shake)\w8\w8`、テレポートは `%(Teleport)`。
- 数字の `\s[2000]` などの裏にある表情名は、元の辞書の `character.kis` と `shell/master/surfacetable.txt` にあった。
- 口調を混ぜない。華和梨は丁寧語まじり、里々は「ボク」、文は短く言い切る、里珠は「ですわ」。

例（`yaya_aitalk.dic` より）:

```
'\p[3]\s[-1]\p[2]\s[2000]\0\s[0]\1\s[1155]ぬるぽがね♪\w8\nソースにちょこちょこかくれんぼ♪\w8…'
```

## 元の辞書から変えたところ

- 起動時間のトークは、元の設定では 1 時間目に「2nd」が出る（`kp.worktime` の閾値の取り方）はずだったが、台詞の意図どおり、1 時間目に「1st」を出す。
- `${里珠怒り}`（未定義だった）は、里珠照れ怒り（3009）にした。`${9}`（未定義だった）は `%(里々ゴースト)`、`${…………}`（未定義だった）は 4 つの「…」にした。
- 元の辞書の台詞 1 件にあった、シェルに無いサーフェス 2009（文の照れ怒り）は 2007（怒り）にした。
- `[harf]` は `[half]` に直した。`alkVanishButtonHold` は `OnVanishButtonHold` として動くようにした。
- 優羽さんのお菓子トークは、元は呼び出し条件の定義が無く動かなかった。題の 4 つ（フルーツゼリー、クッキー、ビスケット、野菜ケーキ）を条件にした。
- 振動（effect.dll）とテレポート（winpos.dll）の SAORI は使わず、`\![move]` で代替した。テレポートは画面端の折り返し判定をしない。
- UD Sensor、Winamp 連携、アプリケーション通知、RSS、壁紙、スケジュール投稿など、今の SSP が通知しない反応も、元のイベント名のまま `yaya_legacy.dic` に移した。
- 元の辞書の誤りを、意図どおりに直した: スケジュール投稿完了（`TalkeSchedulePostComplete` の綴り違いで鳴らなかった）、ウェブサイト更新の本文（`CheckWeb` が呼ばれていなかった）、電池・リソース警告の数字（直前の値を出していた）、`OnSchedule5MinuteToGo`（SSP の名前は `OnSchedule5MinutesToGo`。どちらにも反応する）。
- 作りかけで読み込まれていなかった `ghost-temp-neta.kis` のトーク（暗号化辞書のゴーストに呼ばれた話）を、`\p2` を `\p[2]` に直してランダムトークに加えた。
