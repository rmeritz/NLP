#!/usr/bin/env python
import os
from collections import defaultdict
from operator import itemgetter
from itertools import takewhile

from psycopg2 import connect
from nltk.tokenize import word_tokenize #nltk.download('pickle')
from nltk.corpus import stopwords # nltk.download('stopword')
from pytagcloud import create_tag_image, make_tags

connection = connect(host="dw.hemnet.se", user="analyst", dbname="gobbler_production")

cursor = connection.cursor()
stop = stopwords.words('swedish')

cursor.execute("""select pld.description
                  from property_listing_descriptions as pld,
                         property_listings as pl
                 where pl.id = pld.property_listing_id and
                 ((pl.sold_price - pl.asking_price) / pl.asking_price::float) > 0.6;""")


counted = defaultdict(int)

for record in cursor:
    if record[0]:
        tokens = word_tokenize(record[0].decode("utf-8"), language="swedish")
        for token in tokens:
            word = token.lower()
            if not word in stop and len(word) > 1:
                counted[word] += 1

cursor.execute("""select pld.description
                  from property_listing_descriptions as pld,
                         property_listings as pl
                 where pl.id = pld.property_listing_id and
                 ((pl.asking_price - pl.sold_price) / pl.asking_price::float) > 0.6;""")

for record in cursor:
    if record[0]:
        tokens = word_tokenize(record[0].decode("utf-8"), language="swedish")
        for token in tokens:
            word = token.lower()
            if not word in stop and len(word) > 1:
                counted[word] -= 1


print "Done counting words. Generating image..."

sorted_tag_counts = sorted(counted.iteritems(), key=itemgetter(1), reverse=True)
tag_counts = [(word, count) for word, count in sorted_tag_counts if count > 4]

tags = make_tags(tag_counts, maxsize=120, minsize=5)
create_tag_image(tags, 'diff_wordz.png', size=(900, 600), fontname='Reenie Beanie', background=(0,0,0))

print "Image generated!"
