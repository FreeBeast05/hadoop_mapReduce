import sys

current_word = None
current_count = 0
current_lower=0
word = None

for line in sys.stdin:
    try:
        line = line.strip()
        word, count, have_lower = line.split('\t', 2)
        count = int(count)
        have_lower = int(have_lower)
    except ValueError:
        continue
    if current_word == word:
        current_count += count
        current_lower+=have_lower
    else:
        if current_lower==0:
            print ('{0}\t{1}'.format(current_word, current_count))
        current_count = count
        current_lower=have_lower
        current_word = word

if current_word == word and current_lower==0:
    print('{0}\t{1}'.format(current_word, current_count))

