#!/bin/bash

home=$(cd $(dirname $0);pwd)
yaml_snip=${home}/yaml.snip
json_snip=${home}/json.snip
aws_cfn_doc_repo=$home/aws-cloudformation-user-guide
aws_cfn_doc_dir=${aws_cfn_doc_repo}/doc_source

if [ -e "${yaml_snip}" ];then rm ${yaml_snip}; fi
if [ -e "${json_snip}" ];then rm ${json_snip}; fi

if [ ! -d "aws-cloudformation-user-guide" ];then 
  git clone https://github.com/awsdocs/aws-cloudformation-user-guide.git
fi

cd ${aws_cfn_doc_dir}

# make yaml.snip
for FILE in `grep "^### YAML" aws-resource* | awk -F: '{ print $1 }' | sort -u`
do
  echo "snippet " `sed -n 1P $FILE | sed -e "s/^# //g" -e "s/<a .*//g"` >> ${yaml_snip} 

  start=$(expr $(sed -ne '/^### YAML/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==1 { print $1}') + 1)
  end=$(expr $(sed -ne '/^### YAML/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==2 { print $1}') - 1)

  sed -ne '/^### YAML/,$p' $FILE | \
    sed -ne "${start},${end}p" | \
    sed -e "s/^/  /g" | \
    sed -e "s/\[//g" | \
    sed -e "s/\].*)//g" >> ${yaml_snip}
  echo "" >> ${yaml_snip}
  echo "" >> ${yaml_snip}
done

# make json.snip
for FILE in `grep "^### JSON" aws-resource* | awk -F: '{ print $1 }' | sort -u`
do
  echo "snippet " `sed -n 1P $FILE | sed -e "s/^# //g" -e "s/<a .*//g"` >> ${json_snip} 

  start=$(expr $(sed -ne '/^### JSON/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==1 { print $1}') + 1)
  end=$(expr $(sed -ne '/^### JSON/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==2 { print $1}') - 1)

  sed -ne '/^### JSON/,$p' $FILE | \
    sed -ne "${start},${end}p" | \
    sed -e "s/^/  /g" | \
    sed -e "s/\[//g" | \
    sed -e "s/\].*)//g" >> ${json_snip}
  echo "" >> ${json_snip}
  echo "" >> ${json_snip}
done
