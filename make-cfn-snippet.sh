#!/bin/bash

home=$(cd $(dirname $0);pwd)
aws_cfn_doc_repo=${home}/aws-cloudformation-user-guide
aws_cfn_doc_dir=${aws_cfn_doc_repo}/doc_source

if [ ! -d "aws-cloudformation-user-guide" ];then 
  git clone https://github.com/awsdocs/aws-cloudformation-user-guide.git
fi

cd ${aws_cfn_doc_dir}

for file_type in yaml json
do 

  # initialize
  snip=${home}/snippets/${file_type}.snip
  if [ -e "${snip}" ];then rm ${snip}; fi

  # AWS Resource snippets
  echo "### AWS Resource snippets" >> ${snip}
  for FILE in `grep "^### ${file_type~~}" aws-resource* | awk -F: '{ print $1 }' | sort -u`
  do
    echo "snippet " `sed -n 1P $FILE | sed -e "s/^# //g" -e "s/<a .*//g" -e "s/ /::/g"` >> ${snip} 
  
    start=$(expr $(sed -ne '/^### '${file_type~~}'/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==1 { print $1}') + 1)
    end=$(expr $(sed -ne '/^### '${file_type~~}'/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==2 { print $1}') - 1)
  
    sed -ne '/^### '${file_type~~}'/,$p' $FILE | \
      sed -ne "${start},${end}p" | \
      sed -e "s/^/  /g" | \
      sed -e "s/([^)]*)//g" | \
      sed -e "s/\[//g" -e "s/\]//g" >> ${snip}
    echo "" >> ${snip}
    echo "" >> ${snip}
  done
 

  # Resource Properties snippets
  echo "### Resource Properties snippets" >> ${snip}
  for FILE in `grep "^### ${file_type~~}" aws-properties-* | awk -F: '{ print $1 }' | sort -u`
  do
    echo -n "snippet " >> ${snip}
    echo -n `sed -n 1P $FILE | sed -e "s/^# //g" -e "s/<a .*//g" -e "s/.* //g"` >> ${snip}
    echo $FILE | sed -e "s/aws-properties//g" -e "s/.md//g" >> ${snip}
  
    start=$(expr $(sed -ne '/^### '${file_type~~}'/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==1 { print $1}') + 1)
    end=$(expr $(sed -ne '/^### '${file_type~~}'/,$p' $FILE | grep -n "\`\`\`" | awk -F: 'NR==2 { print $1}') - 1)
  
    sed -ne '/^### '${file_type~~}'/,$p' $FILE | \
      sed -ne "${start},${end}p" | \
      sed -e "s/^/  /g" | \
      sed -e "s/([^)]*)//g" | \
      sed -e "s/\[//g" -e "s/\]//g" >> ${snip}
    echo "" >> ${snip}
    echo "" >> ${snip}
  done
done

# refact
sed -i -e "s/ $//g" ${home}/snippets/*.snip
