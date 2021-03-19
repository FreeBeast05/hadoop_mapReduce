
#!/usr/bin/env bash

WORK_DIR="streaming_wc_work"
NUM_REDUCERS=8
OUT_DIR="streaming_wc_result"
hadoop fs -rm -r -skipTrash $WORK_DIR*
hadoop fs -rm -r -skipTrash $OUT_DIR*

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.name="wiki_wordcout" \
    -D stream.num.map.output.key.fields=2 \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -files mapper.py,reducer.py \
    -mapper mapper.py \
    -combiner reducer.py \
    -reducer reducer.py \
    -input /data/wiki/en_articles \
    -output ${WORK_DIR}

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.name="wordcout_sort" \
    -D stream.num.map.output.key.fields=2 \
    -D mapreduce.job.reduces=1 \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -D mapreduce.partition.keycomparator.options="-k2,2nr -k1" \
    -mapper cat \
    -combiner cat \
    -reducer cat \
    -input ${WORK_DIR} \
    -output ${OUT_DIR}


hdfs dfs -cat ${OUT_DIR}/part-00000 | head -10

