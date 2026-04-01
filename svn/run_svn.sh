#!/usr/bin/env bash
set -uo pipefail

# 1. Настройка сервера
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="$BASE_DIR/svn_repo"
REPO_URL="file://$REPO_PATH"

rm -rf "$REPO_PATH" app_red app_blue

svnadmin create "$REPO_PATH"
svn mkdir -m "Init" "$REPO_URL/trunk" "$REPO_URL/branches"

# 2. Пользователь red (r0)
echo "--- Red: r0 ---"
svn checkout "$REPO_URL/trunk" app_red
cd app_red
unzip -o ../commits/commit0.zip -d .
svn add --force *
svn commit -m "r0" --username red
cd ..

# 3. Пользователь blue (r1-r3)
echo "--- Blue: r1-r3 ---"
svn copy "$REPO_URL/trunk" "$REPO_URL/branches/develop" -m "Create develop"
svn checkout "$REPO_URL/branches/develop" app_blue
cd app_blue

# r1
unzip -o ../commits/commit1.zip -d .
svn add --force *
svn commit -m "r1" --username blue

# r2
unzip -o ../commits/commit2.zip -d .
svn add --force *
svn commit -m "r2" --username blue

# r3
unzip -o ../commits/commit3.zip -d .
svn rm --force "DGL609Kely.B7s" 2>/dev/null || rm -f "DGL609Kely.B7s"
svn add --force *
svn commit -m "r3" --username blue
cd ..

# 4. Пользователь red (r4 на feature)
echo "--- Red: r4 ---"
svn copy "$REPO_URL/branches/develop" "$REPO_URL/branches/feature" -m "Create feature"
cd app_red
svn switch "$REPO_URL/branches/feature"
unzip -o ../commits/commit4.zip -d .
# Удаляем CLtKj0iUy0.XzG
svn rm --force "CLtKj0iUy0.XzG" 2>/dev/null || rm -f "CLtKj0iUy0.XzG"
svn add --force *
svn commit -m "r4" --username red
cd ..

# 5. Пользователь blue (r5-r6)
echo "--- Blue: r5-r6 ---"
cd app_blue
# r5
unzip -o ../commits/commit5.zip -d .
svn rm --force "CLtKj0iUy0.XzG" 2>/dev/null || rm -f "CLtKj0iUy0.XzG"
svn add --force *
svn commit -m "r5" --username blue

# r6
unzip -o ../commits/commit6.zip -d .
svn rm --force "CesATB7sDG.aSb" 2>/dev/null || rm -f "CesATB7sDG.aSb"
svn add --force *
svn commit -m "r6" --username blue
cd ..

# 6. Пользователь red (r7)
echo "--- Red: r7 ---"
cd app_red
svn switch "$REPO_URL/trunk"
unzip -o ../commits/commit7.zip -d .
svn add --force *
svn commit -m "r7" --username red
cd ..

# 7. Пользователь blue (r8)
echo "--- Blue: r8 ---"
cd app_blue
unzip -o ../commits/commit8.zip -d .
# Удаляем "*"
svn rm --force "*" 2>/dev/null || rm -f "*"
svn add --force *
svn commit -m "r8" --username blue
cd ..

# 8. Мердж r9 (develop -> trunk)
echo "--- Red: Слияние r9 ---"
cd app_red
svn switch "$REPO_URL/trunk"
svn update
svn merge "$REPO_URL/branches/develop" --accept postpone || true

# Бинарные файлы просто подставляем из архива
unzip -o ../commits/commit9.zip -d . -x "*.java"
svn rm --force "7sDGL609Ke.ATB" 2>/dev/null || rm -f "7sDGL609Ke.ATB"

while true; do
    echo "БИНАРНИКИ ОБНОВЛЕНЫ. ИСПРАВЬ JAVA ДЛЯ r9."
    svn status
    echo ">>> Исправь .java файлы, СОХРАНИ и нажми [ENTER]:"
    read -r _
    # Чистим статусы конфликтов перед коммитом
    svn status | grep '^C' | awk '{print $2}' | xargs -I{} svn resolved "{}" 2>/dev/null || true
    svn add --force * 2>/dev/null || true
    if svn commit -m "r9 merge" --username red; then
        break
    fi
done

# 9. пользователь red (r10-r12)
svn switch "$REPO_URL/branches/feature"
# r10
unzip -o ../commits/commit10.zip -d .
svn add --force *
svn commit -m "r10" --username red

# r11
unzip -o ../commits/commit11.zip -d .
svn rm --force "PEdAP8QFji.ej0" 2>/dev/null || rm -f "PEdAP8QFji.ej0"
svn add --force *
svn commit -m "r11" --username red

# r12
unzip -o ../commits/commit12.zip -d .
svn add --force *
svn commit -m "r12" --username red

# 10. мердж r13 (feature -> trunk)
echo "--- Red: Слияние r13 ---"
svn switch "$REPO_URL/trunk"
svn update
svn merge "$REPO_URL/branches/feature" --accept postpone || true

unzip -o ../commits/commit13.zip -d . -x "*.java"

while true; do
    echo "БИНАРНИКИ ОБНОВЛЕНЫ. ЖДУ JAVA ДЛЯ r13."
    svn status
    echo ">>> Исправь .java файлы, СОХРАНИ и нажми [ENTER]:"
    read -r _
    svn status | grep '^C' | awk '{print $2}' | xargs -I{} svn resolved "{}" 2>/dev/null || true
    svn resolved "CLtKj0iUy0.XzG" 2>/dev/null || true
    svn add --force * 2>/dev/null || true
    if svn commit -m "r13 merge" --username red; then
        break
    fi
done

# 11. r14
unzip -o ../commits/commit14.zip -d .
svn add --force *
svn commit -m "r14" --username red

echo "Готово"