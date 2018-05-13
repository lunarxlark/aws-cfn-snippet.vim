#!/bin/bash

home=$(cd $(dirname $0);pwd)
result=${home}/yaml.snip
aws_cfn_doc_repo=$home/aws-cloudformation-user-guide
aws_cfn_doc_dir=${aws_cfn_doc_repo}/doc_source

git clone https://github.com/awsdocs/aws-cloudformation-user-guide.git

cd ${aws_cfn_doc_dir}

if [ -e "${result}" ];then rm ${result}; fi

for FILE in `grep "^### YAML" aws-resource* | awk -F: '{ print $1 }' | sort -u`
do
  echo "snippet " `sed -n 1P $FILE | sed -e "s/^# //g" -e "s/<a .*//g"` >> ${result} 

  start=$(expr $(sed -ne '/^### YAML/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==1 { print $1}') + 1)
  end=$(expr $(sed -ne '/^### YAML/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==2 { print $1}') - 1)

  sed -ne '/^### YAML/,$p' $FILE | \
    sed -ne "${start},${end}p" | \
    sed -e "s/^/  /g" | \
    sed -e "s/\[//g" | \
    sed -e "s/\].*)//g" >> ${result}
  echo "" >> ${result}
  echo "" >> ${result}
done
