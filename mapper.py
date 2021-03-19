import sys
import re
all_word=[]
for line in sys.stdin:
    try:
        article, text = line.strip().split('\t', 1)
    except ValueError as e:
        continue
    words_raw = re.split('[^A-Za-z0-9]', text)
    words= set(filter(lambda strin: re.match(r'[A-Za-z]{1}[a-z]{5,8}\b', strin), words_raw))
    for word in words:
        if word.istitle() and word[1:].islower():
            print('{0}\t{1}\t{2}'.format(word.lower(), 1,0))
        else:
            print('{0}\t{1}\t{2}'.format(word.lower(), 1,1))



