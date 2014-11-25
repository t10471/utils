# -*- coding: utf-8 -*-

#  python  md.py /home/clang/workspace/HeadFistC/pointer/memo.md /var/www/html/memo.html

import markdown
import sys
import os
import textwrap
import codecs


def main():
    in_file = sys.argv[1]
    out_file = sys.argv[2]
    if in_file is None:
        print "require input file"
        exit()
    if out_file is None:
        print "require outut file"
        exit()

    print "infile = {0}".format(in_file)
    print "outfile = {0}".format(out_file)
    if not os.path.exists(out_file):
        with codecs.open(out_file, 'w', encoding="utf-8") as f:
            f.write("")
    html = textwrap.dedent('''\
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<link rel="stylesheet" href="github.css" type="text/css">
</head>
<body>
''')
    # f = codecs.open(in_file, mode="r", encoding="utf-8")
    # tmp = markdown.markdown(f.read(), output_format="html5")
    # f.close()
    # html += tmp
    with codecs.open(in_file, 'r', encoding="utf-8") as f:
        tmp = markdown.markdown(f.read(), output_format="html5",
                                extensions=['markdown.extensions.fenced_code',
                                            'markdown.extensions.codehilite',
                                            'gfm'])
        #  tmp =  markdown.markdown(f.read(), output_format="html5",
        #                           extensions= ['gfm'])
        html += tmp
    html += textwrap.dedent('''\
</body>
</html>
''')
    with codecs.open(out_file, 'w', encoding="utf-8") as f:
        f.write(html)


if '__main__' == __name__:
    main()
