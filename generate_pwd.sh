students=(
  student65555
  student1121
      )
      for student in "${students[@]}"; do
              p=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w16 | head -n1)
              useradd -m $student
              (echo "$p"; echo "$p") | passwd $student
              usermod -a -G rt $student
              echo "${student} ${p}" >> passwords.txt
      done
