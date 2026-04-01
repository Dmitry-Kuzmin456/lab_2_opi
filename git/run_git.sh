#!/usr/bin/env bash
set -euo pipefail

# Переходим в директорию скрипта
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "cd app_red"
cd app_red

# Инициализация первого репозитория (красный)
git init
git config user.name "red_user"
git config user.email "red@mail"
git remote add origin https://github.com/Dmitry-Kuzmin456/opi_lab_2

git fetch origin main
git checkout main 

unzip -o ../commits/commit0.zip -d .
git add .
git commit -m "r0"
git push --set-upstream origin main
echo "Revision 0 pushed"

# клонирование для второго репозитория (синего)
cd ..
git clone https://github.com/Dmitry-Kuzmin456/opi_lab_2 app_blue
echo "cd app_blue"
cd app_blue

git config user.name "blue_user"
git config user.email "blue@mail"
git checkout -b develop

unzip -o ../commits/commit1.zip -d .
git add .
git commit -m "r1"
git push --set-upstream origin develop
echo "Revision 1 pushed"

unzip -o ../commits/commit2.zip -d .
git add .
git commit -m "r2"
git push
echo "Revision 2 pushed"

unzip -o ../commits/commit3.zip -d .
rm DGL609Kely.B7s
git add .
git commit -m "r3"
git push
echo "Revision 3 pushed"

# Возврат к красному
echo "cd app_red"
cd ../app_red

git fetch
git checkout develop
git checkout -b feature
unzip -o ../commits/commit4.zip -d .
rm CLtKj0iUy0.XzG
git add .
git commit -m "r4"
git push --set-upstream origin feature
echo "Revision 4 pushed"

# Ревизии синего
cd ../app_blue
unzip -o ../commits/commit5.zip -d .
rm CLtKj0iUy0.XzG
git add .
git commit -m "r5"
git push
echo "Revision 5 pushed"

unzip -o ../commits/commit6.zip -d .
rm CesATB7sDG.aSb
git add .
git commit -m "r6"
git push
echo "Revision 6 pushed"

# Ревизия красного
echo "cd app_red"
cd ../app_red
git checkout main
unzip -o ../commits/commit7.zip -d .
git add .
git commit -m "r7"
git push
echo "Revision 7 pushed"

# Ревизия синего
cd ../app_blue
unzip -o ../commits/commit8.zip -d .
rm "*"
git add .
git commit -m "r8"
git push
echo "Revision 8 pushed"

# --- СЛИЯНИЕ r9 ---
echo "cd app_red"
cd ../app_red
git checkout develop
git pull
git checkout main

echo "--- Слияние develop в main (r9) ---"
git merge develop || true

# Автоматически чиним бинарники (заменяем их из архива)
unzip -o ../commits/commit9.zip -d . -x "*.java"
rm 7sDGL609Ke.ATB

while true; do
    echo "БИНАРНИКИ И '*' ОБНОВЛЕНЫ ИЗ АРХИВА."
    git status --short
    echo ">>> Открой .java файлы, исправь конфликты, СОХРАНИ и нажми [ENTER]:"
    read -r _
    
    git add . 
    if git commit -m "r9 merge"; then
        break
    else
        echo "Ошибка: в файлах остались маркеры конфликтов или файлы не сохранены. Попробуй еще раз."
    fi
done

git push
echo "Revision 9 pushed"

# Ревизии r10-r12
git checkout feature
unzip -o ../commits/commit10.zip -d .
git add .
git commit -m "r10"
git push
echo "Revision 10 pushed"

unzip -o ../commits/commit11.zip -d .
rm PEdAP8QFji.ej0
git add .
git commit -m "r11"
git push
echo "Revision 11 pushed"

unzip -o ../commits/commit12.zip -d .
git add .
git commit -m "r12"
git push
echo "Revision 12 pushed"

# --- СЛИЯНИЕ r13 ---
git checkout main
echo "--- Слияние feature в main (r13) ---"
git merge feature || true

# Бинарные файлы просто подставляем из архива
unzip -o ../commits/commit13.zip -d . -x "*.java"

while true; do
    echo "БИНАРНИКИ ОБНОВЛЕНЫ. ЖДУ ИСПРАВЛЕНИЯ JAVA."
    git status --short
    echo ">>> Исправь .java файлы, СОХРАНИ и нажми [ENTER]:"
    read -r _
    
    git add . 
    if git commit -m "r13 merge"; then
        break
    else
        echo "Ошибка коммита r13. Проверь файлы и нажми ENTER снова."
    fi
done

git push
echo "Revision 13 pushed"

unzip -o ../commits/commit14.zip -d .
git add .
git commit -m "r14"
git push
echo "Revision 14 pushed"

echo "ГОТОВО! Лабораторная работа выполнена."