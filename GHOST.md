# GHOST.md

「SHIORIES」に固有の情報です。AI エージェントは、作業の前に読みます。
作者が自由に書き換えるファイルです。

## このゴーストについて

- 伺か（ukagaka）のゴースト。SHIORI たちが擬人化して、ゴーストを動かす舞台裏を語る。
- 2006 年に華和梨（KAWARI）8 とミドルウェア OpenKEEPS で作られた。**YAYA 6 コア版として、辞書を全面的に組み直した**（シェルはそのまま）。
- 配布元: Ukagaka Tech Team（https://ukatech.shillest.net/ ）、リポジトリ: https://github.com/YAYA-shiori/shiories
- ネットワーク更新の URL（`On_homeurl`）は `https://yaya-shiori.github.io/shiories/`（GitHub Pages）。`ghost/master/dic/normal/yaya_homeurl.dic` と `ghost/master/dic/emerg/yaya_homeurl.dic` の 2 か所に書く。この URL の直下に `updates2.dau`、`delete.txt`、nar を GitHub Actions でデプロイする（`updates2.dau` と `updates.txt` は `.gitignore` で除外してある。`ghost/master/dic/system` は submodule で、GitHub の raw からは配れないため）。
- 配布物は `.github/workflows/auto_deploy.yml` が作る。辞書チェック（`auto check`）が通った `main` / `master` の push ごとに、`.github/scripts/build-site.ps1` が nar（`.narignore` で除外）と更新ファイル一式（`.updateignore` で除外）を作って Pages に出す。手元でも `pwsh ./.github/scripts/build-site.ps1 -OutDir site`（`-ListOnly` で一覧だけ）で同じものが作れる。リポジトリの Settings > Pages > Source は「GitHub Actions」にしておく。
- nar は GitHub Releases にも置く。タグ `latest` の Release 1 件だけを持ち、デプロイのたびに前の Release をタグごと消して、最新の nar 1 つで作り直す（`auto_deploy.yml` の `release` ジョブ。Pages のデプロイが成功したあとに動く）。固定の URL は `https://github.com/YAYA-shiori/shiories/releases/latest/download/shiories.nar`。
- 同梱バルーン `shiories_balloon/` は nar には入れるが、ゴーストの更新ファイルには入れない（`.updateignore`）。バルーンには単独の `updates2.dau` と `updates.txt` を作り、`https://yaya-shiori.github.io/shiories/shiories_balloon/` に出す。`shiories_balloon/descript.txt` の `homeurl` がそこを指す。どのバルーンを対象にするかは、`install.txt` の `balloon.directory`（と `balloon.source.directory`）から読む。
- 旧版の利用者は、旧版が報告する `http://ms.shillest.net/ghost/shiories/` から更新する。この版を届けるには、そちらにも公開する必要がある。
- ゴーストの説明（遊び方、インストール、作った人、ライセンス、連絡先、履歴）は `README.md` 1 つにまとめてある。Markdown で書く。SSP が読む利用者向けの説明で、GitHub のトップにも出る。`readme.txt` は置かない。

## ライセンス

- ゴースト（辞書）の著作権者は「Ukagaka Tech Team」。ライセンスは クリエイティブ・コモンズ 表示 2.5（`README.md`）。
- シェル `shell/master/` の作者はボトル猫氏（`shell/master/descript.txt`）。**画像は編集しない。**
- 同梱バルーン `shiories_balloon/` は、Ukagaka Tech Team がこのゴースト向けに作った（`descript.txt` の `craftman` は Ukagaka Tech Team）。ライセンスは CC0 1.0（パブリックドメイン献呈。ゴースト本体の CC 表示 2.5 とは別）。画像は編集してよい。利用者向けの説明は `shiories_balloon/README.md`。

## キャラクターとサーフェス

普段出ているのは華和梨・里々・文の 3 人。里珠はゲストキャラクターで、たまにしか出ない（出番は、里珠が登場するトークだけ）。**トークの頭では全員を初期状態にそろえる**（`\p[3]\s[-1]\p[2]\s[2000]\1\s[1000]\0\s[0]`。里珠は消した状態）。

| スコープ | キャラクター | 人物像（既存のトークから） | 使えるサーフェス |
|---|---|---|---|
| `\0`（`\h`） | 華和梨 | SHIORI「華和梨」。長女で、眼鏡。しっかり者のツッコミ役だが、デバッガ役のキャラクターに弱く、すぐ落ち込む。里々や文を「里々」「文ちゃん」と呼ぶ | 0 素 / 1 照れ / 2 驚き / 3 不安 / 4 落ち込み / 5 微笑み / 6 目閉じ / 7 怒り / 8 呆れ / 9 照れ怒り / 11 ちょっと照れ / 14 落ち込み涙 / 100 素2 / 101 照れ2 / 102 驚き2 / 103 不安2 / 104 ちょっと落ち込み / 105 笑い / 106 目閉じ2 / 108 呆れ2 / 111 髪触り照れ / 114 泣き笑い / 150 視線合わせ素 / 152 え？ / 153 考え中 / 155 照れ笑い / 158 ちょっと呆れ / 202 メガネメガネ / 208 もしもし？ |
| `\1`（`\u`） | 里々 | SHIORI「里々」。元気で無邪気な**男の子**（見た目は女の子）。「ボク」。自分の人気（シェア）が気になる | 1000 素 / 1001 照れ / 1002 驚き / 1003 不安 / 1004 落ち込み / 1005 微笑み / 1006 目閉じ / 1007 怒り / 1008 呆れ / 1009 照れ怒り / 1101 赤面 / 1105 幸せ / 1106 祈り / 1108 苦笑 / 1151 照れ困惑 / 1155 わはー / 1205 照れ幸せ |
| `\p[2]` | 文（あや） | SHIORI「文」（AYA）。無口でお茶好き。ぼそっと毒を吐く。「ふみ」と呼ぶと泣く。みかん箱（文箱）に隠れる | 2000 素 / 2001 照れ / 2002 驚き / 2003 不安 / 2004 落ち込み / 2005 微笑み / 2006 目閉じ / 2007 怒り / 2010 / 2050 お茶 / 2100 みかん箱 / 2101 うろたえ / 2106 祈り / 2150 受信中 |
| `\p[3]` | 里珠（ゲスト） | SHIORI「里珠」。Perl を利用した重厚長大な SHIORI。「デスクトップの女王」。高笑いする縦ロール。重いと言われると怒る | 3000 素 / 3001 こけ / 3005 高笑い / 3009 照れ怒り |

- 消すときは `\s[-1]`。里珠は普段出ていない（トークの頭で `\p[3]\s[-1]`）。
- 華和梨の当たり判定（`surfaces.txt` の `collision`）は `Head`、`Face`、`Bust`。里々は `Head`、`Face`、`Bust`、`Crotch`。文は `Head`、`Face`、`Bust`、`Antenna`、`Jewel`、`Box`（みかん箱のとき）、`Nar`。
- 使うサーフェス番号は上の表にあるものだけ。`element*.png` は部品なので、トークでは指定しない。
- サーフェス 2009（文の照れ怒り）は、`surfaces.txt` に定義がない。使わない（元の辞書の台詞 1 件は 2007 に置き換えた）。

## 辞書の構成

- `ghost/master/yaya.txt` が `dic/normal` を読む。辞書エラーのときは `yaya_emerg.txt` が `dic/emerg` を読む（緊急モード）。
- `ghost/master/dic/system/` はシステム辞書（yaya-dic の submodule）。**編集しない。**
- 旧版（華和梨 + OpenKEEPS）の `kawarirc.kis`、`openkeeps/`、`template/`、`saori/` は無くなった。`delete.txt` で、ネットワーク更新のときに消す。
- `neta.txt` は作者のメモ（ネタ箇条書きと会話サンプル）。辞書には読み込まれない。
- `shiories_balloon/` は同梱するバルーン「SHIORIES バルーン」。`install.txt` の `balloon.directory` が指す。画像は `work/balloon/make-balloon.ps1` が作る（`DESIGN.md` の「バルーン」）。
- 文字コードは UTF-8（BOM なし、LF）。**`shell/` だけは元の Shift_JIS・CRLF のまま**で、`.gitattributes` と `.editorconfig` で Git やエディタに変換させないようにしてある（`shell/master/descript.txt` と `surfacetable.txt`）。`README.md`、`neta.txt`、バルーンのテキストは UTF-8 に変換した（`charset,UTF-8` を明記）。

## デザイン

色、書体、サムネイル（`ghost/master/thumbnail.png`）、同梱バルーン、右クリックメニュー（`ghost/master/menu/`）の見た目など、画像と文字の決まりは `DESIGN.md` にある。画像や文字を新しく作るときは、先に `DESIGN.md` を読む。

## イベントと辞書ファイルの対応

| ファイル（`ghost/master/dic/normal/`） | 主な中身 |
|---|---|
| `yaya_core.dic` | 変数の初期化（`OnSystemLoad.SHIORIES`）、起動・終了の記録（`BootStart` `MarkClosed`）、時間帯の判定（`GetTimeZone`） |
| `yaya_aitalk.dic` | ランダムトーク（`RandomTalkEx`）、チェイントーク、時報・起動時間・重なり（`OnMinuteChange`）、見切れ（`OnSecondChange`）、サーフェス復帰（`OnSurfaceRestore`） |
| `yaya_bootend.dic` | 初回起動 `OnFirstBoot`、起動 `OnBoot`（時間帯ごとに `Boot_*`）、終了 `OnClose`（`Close_*`） |
| `yaya_mouse.dic` | マウスへの反応。関数名は「種別＋スコープ番号＋当たり判定名」。撫で反応は段階式（`StrokeLimit*` `StrokeLoop*` `MouseMove*_<段階>`）。`OnMouseDown` は何も話さず、最後に押されたキャラを `menuscope` に覚える（右クリックメニューの見た目の切り替え用）。あやりりす（システム辞書）の同名の `OnMouseDown` ではなく、こちらが呼ばれる（`shiori.ps1` で確かめた） |
| `yaya_menu.dic` | メニュー `OpenMenu` と、選択肢ごとの処理 `Menu_*`、ユーザー名の変更 |
| `yaya_change.dic` | ゴーストの切り替え。`OnGhostChanging_<相手の\0側の名前>` `OnGhostChanged_<…>`、無ければ `…Other` |
| `yaya_communicate.dic` | ユーザー・他のゴーストとの会話（`ReplyTo*` `TalkTo*`） |
| `yaya_etc.dic` | 汎用イベントトーク（インストール、更新、メール等）、最小化復帰、消滅指示、時計合わせ、ヘッドライン、スクリーンセーバー終了、壁紙の変更、解像度の変更 |
| `yaya_notify.dic` | カレンダー、「きのこ」「猫どりふ」、MATERIA、システムリソースの通知への反応 |
| `yaya_legacy.dic` | 元の OpenKEEPS のイベント名のまま移した反応。アプリケーション通知（`OnApplication*`）、`OnWebsiteUpdateNotify`、UD Sensor（`OnUdsUpdate`）、Winamp / iTunes（`OnMusicPlay` `OnMusicPlayEx`）、RSS（`OnRSS*`）、壁紙（`OnWallpaperChange`）、スケジュール投稿、電池残量。今の SSP が通知しないものも含む |
| `yaya_effect.dic` | 演出（`Shake` 振動、`Teleport` テレポート）と `ChangeGhostOrClose` |
| `yaya_string.dic` | ユーザー名、右クリックメニューのボタン名、お勧めサイト・ポータルサイト（`On_*`）、サイトが選ばれたときの反応、右クリックメニューの画像と色（`On_menu.*`、`MenuFile` `MenuColor` `MenuScope`。`menuscope` に合わせて 4 組を返し分ける） |
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
- 口調を混ぜない。一人称、呼び方、語尾は次の「口調」に従う。

例（`yaya_aitalk.dic` より）:

```
'\p[3]\s[-1]\p[2]\s[2000]\0\s[0]\1\s[1155]ぬるぽがね♪\w8\nソースにちょこちょこかくれんぼ♪\w8…'
```

## 口調

新しい台詞は、既存の台詞（`ghost/master/dic/normal/` の約 1300 発話）の傾向に合わせる。以下は話し手ごとに数えて拾った癖で、数は目安。

| | 華和梨（`\0`） | 里々（`\1`） | 文（`\p[2]`） | 里珠（`\p[3]`） |
|---|---|---|---|---|
| 一人称 | 私 | **ボク**に統一する（「ボク達」も）。「私」は使わない。「～のね」「～のよねぇ」のような女言葉の語尾も使わない | 私。自分を「文」「あやでーす」と呼ぶこともある | 私、わたくし（同じ台詞の中でもゆれる） |
| 相手への二人称 | 里々と文には「あんた」「あんたたち」「あんたら」（叱る、あきれる）。里々には「あなた」も使う。里珠とユーザーには「あなた」 | ほとんど使わず、名前で呼ぶ | 使わず、名前で呼ぶ（里々は「里々」と呼び捨て） | あなた、あなた達 |
| 文末 | ～わよ、～わね、～のよ、～でしょ、～じゃない、～なさい、～よね。砕けた女言葉 | ～だよ、～だよね、～の？、～じゃん、～だもん、～ちゃった、～かな | 体言止めや短い断定（「基本。」「任務完了。」「自爆。」）。注意は男言葉寄り（～するな、～行け、～返してこい、～禁止、～ぞ）。たまに～わ、～ね、～の | ～ですわ、～ですの、～ことよ、～ませんこと、～遊ばせ、～かしら、～なさい |
| 口癖・記号 | 「！」「！？」が多い。吃る（「ち、違うのよこれは！」「な、何？」） | 「～」と「♪」が多い（「行ってきま～す♪」「えへへ～♪」）。「わは～」「にゃはは」「わほーい」「やたー」「えーと」「んっと」 | 話し出しは「…」の沈黙（約半数）。感嘆符はめったに使わず、熱くなったときだけ。動作は（げしっ）のように括る | 高笑い「お～っほっほっほ！」（伸ばす長さは自由）。「！？」が多い |
| 怒る・動揺する | 短い命令に変わる（「おやめっ！！」「散れ」「帰れ」「失せろ」）。落ち込むと「ううっ…」「えぐえぐ」。ふんと言って強がる | 「ひどーい！」「いたいの…」「嫌～」。拗ねる | 「…滅。」「うるさい。（げしっ）」。怒ると短く切る（まれに「邪道っ！！」と声を上げる） | 「重い」と言われると逆上し、口調が崩れる（「私が重いですって！？」「失礼ね！」「調子に乗るんじゃないわよ」）。崩れた直後に「仕様ですわ！」とお嬢様に戻ることもある |
| 丁寧語を使うとき | 里珠とユーザーには丁寧語（「里珠さん、～と思うんですが」「どうしたんです、そんな重装備で」「はい、あなたとお話ですね」）。里々と文にはくだけた口調。挨拶（「初めまして、華和梨です」「お疲れ様です」「〇〇さんに交代します」）と、システム通知の「～です。」（`yaya_etc.dic`）も丁寧語 | 変わらない | 変わらない（自己紹介だけ「～です」） | 変わらない |

呼び方（呼ぶ人が行、呼ばれる人が列）:

| | 華和梨 | 里々 | 文 | 里珠 |
|---|---|---|---|---|
| 華和梨 | — | 里々（呼び捨て。まれに「里々ちゃん」） | 文ちゃん | 里珠さん |
| 里々 | 華和梨姉（華和梨ねーちゃん） | — | 文姉ちゃん、文姉、文ねえ（ゆれる） | 里珠さん |
| 文 | 華和梨姉 | 里々（呼び捨て） | — | 名前では呼ばない（「重量級縦ロール」「重いの」「宇宙語の塊」） |
| 里珠 | 華和梨さん | 個別に呼ぶ台詞は無い（まとめて「あなた達」） | 同左 | — |

- 作中に出てくる作者は、華和梨が敬称を付けずに、里々と文が「さん」を付けて呼ぶ。デバッガ役のキャラクターは、華和梨と里々が役職名に「さん」を付けて呼び、華和梨と文は「アイツ」「あいつ」とも言う。具体的な呼び名は、既存の台詞（`ghost/master/dic/normal/`）に合わせる。
- ユーザーは `%(username)` で呼ぶ。名前を使わずに一般に言うときは、華和梨も里珠も「ユーザーさん（達）」。
- 他のゴーストは、里々は「〇〇さん」「〇〇ちゃん」、華和梨は「〇〇さん」。
- 「ですわ」は里珠だけ。辞書の中で他の 3 人は使わない。「ボク」を使うのは里々だけ。
- 里々は姉を呼び捨てにしない（「華和梨姉、イタイノ…」）。
- 文は「…」の沈黙から入って、短く言い切る。
- 華和梨のツッコミは、里々には「あんた」、文には「文ちゃん」と名前で。文をかばう場面は「文ちゃんは絶対零度の毒舌だけど、いい子なのよ？」。

## 演出

- 振動（`%(Shake)`）とテレポート（`%(Teleport)`）は、SAORI（effect.dll、winpos.dll）を使わず、`\![move]` で動かす（`yaya_effect.dic`）。テレポートは画面端の折り返しを判定しない。振動はオプション `option_shake` が 0 のとき何も出さない。
