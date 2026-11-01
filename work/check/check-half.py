#!/usr/bin/env python
"""トークの `\\n\\n[half]` の付け方を点検する。

決まり: 各スコープの最初の発話には `\\n\\n[half]` を付けない。
話し手が交代して、そのスコープが 2 回目以降に話すときだけ付ける。
`\\_s[0,1]…\\_s`（同時発話）で話したスコープは、話し済みとして数える。

使い方（リポジトリのルートで）:
    python -I -X utf8 work/check/check-half.py          # 点検だけ。誤りがあれば終了コード 1
    python -I -X utf8 work/check/check-half.py --fix    # 誤りの \\n\\n[half] を取り除く
    python -I -X utf8 work/check/check-half.py DIR      # 点検する辞書の場所を変える

ghost/master/dic/system（システム辞書）は見ない。
"""
import os
import pathlib
import re
import sys

# 呼び出し側（PowerShell）は出力を UTF-8 として読む。コンソールの文字コードに任せない。
sys.stdout.reconfigure(encoding='utf-8')
# GitHub Actions では、誤りを注釈（ファイルと行）にする。
ANNOTATE = os.environ.get('GITHUB_ACTIONS') == 'true'
HALF = '\\n\\n[half]'
LIT = re.compile(r'"[^"]*"|\'[^\']*\'')
TOK = re.compile(
    r'(?P<half>\\n\\n\[half\])'
    r'|(?P<scope>\\p\[(?P<pn>\d+)\]|\\h|\\u|\\0|\\1)'
    r'|(?P<sync>\\_s(?:\[[\d,]*\])?)'
    r'|(?P<tag>\\(?:s\[-?\d+\]|w\d|n(?:\[[^\]]*\])?|e|-|!\[[^\]]*\]|b\[[^\]]*\]|i\[[^\]]*\]|c\[[^\]]*\]|_[a-z]\[[^\]]*\]|_[a-z]))'
    r'|(?P<mac>%\((?:Shake|Teleport)\))'
    r'|(?P<ch>.)', re.S)
SCOPE = {'\\h': 0, '\\u': 1, '\\0': 0, '\\1': 1}


def find_first(s):
    """最初の誤り（まだ話していないスコープに付いた \\n\\n[half]）の (開始, 終了, スコープ) を返す。"""
    cur = 0
    spoken = set()
    sync = None
    for t in TOK.finditer(s):
        k = t.lastgroup
        if k == 'scope':
            cur = int(t.group('pn')) if t.group('pn') else SCOPE[t.group('scope')]
        elif k == 'sync':
            g = t.group('sync')
            sync = None if g == '\\_s' else {int(x) for x in g[4:-1].split(',') if x}
        elif k == 'half':
            if cur not in spoken:
                return t.start(), t.end(), cur
        elif k == 'ch':
            spoken.add(cur)
            if sync:
                spoken |= sync
    return None


def main(argv):
    fix = '--fix' in argv
    args = [a for a in argv if not a.startswith('--')]
    root = pathlib.Path(args[0] if args else 'ghost/master/dic')
    count = 0
    for f in sorted(root.rglob('*.dic')):
        if 'system' in f.parts:
            continue
        lines = f.read_bytes().decode('utf-8').split('\n')
        changed = False
        for i, line in enumerate(lines):
            def sub(m):
                nonlocal count
                q, body = m.group(0)[0], m.group(0)[1:-1]
                if '\\' not in body:
                    return m.group(0)
                while (r := find_first(body)) is not None:
                    count += 1
                    message = f'スコープ {r[2]} の最初の発話に {HALF} がある'
                    print(f'{f}:{i + 1}: {message}: '
                          f'…{body[max(0, r[0] - 20):r[0]]}[{HALF}]{body[r[1]:r[1] + 20]}…')
                    if ANNOTATE and not fix:
                        print(f'::error file={f.as_posix()},line={i + 1},title=half::{message}')
                    if not fix:
                        break
                    body = body[:r[0]] + body[r[1]:]
                return q + body + q
            new = LIT.sub(sub, line)
            if new != line:
                lines[i] = new
                changed = True
        if changed and fix:
            f.write_bytes('\n'.join(lines).encode('utf-8'))
    print(f'{count} 件' + ('を修正した' if fix else ''))
    return 1 if count and not fix else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
