students=(
  student6
  student2
  student3
)
for student in "${students[@]}"; do
p=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
useradd -m $student -p $p
echo "${student} ${p}" >> passwords.txt
done
