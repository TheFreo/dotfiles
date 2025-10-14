#!/bin/sh

# Укажите путь к директории с обоями
WALLPAPER_DIR="$HOME/Wall"
INDEX_FILE="$HOME/.wallpaper_index.txt"

# Создание файла индекса, если он не существует
if [ ! -f "$INDEX_FILE" ]; then
    echo 0 > "$INDEX_FILE"
fi

# Чтение текущего индекса
CURRENT_INDEX=$(cat "$INDEX_FILE")

# Получение массива изображений
WALLPAPERS=("$WALLPAPER_DIR"/*.{jpg,png,jpeg})

# Подсчет количества изображений
WALLPAPER_COUNT=${#WALLPAPERS[@]}

# Проверка, чтобы индекс был в пределах массива
if [ $CURRENT_INDEX -ge $WALLPAPER_COUNT ]; then
    CURRENT_INDEX=0
fi

# Установка обоев
swww img ${WALLPAPERS[$CURRENT_INDEX]} --transition-type simple --transition-step 80

# Увеличение индекса и сохранение его обратно в файл
NEW_INDEX=$((CURRENT_INDEX + 1))
echo $NEW_INDEX > "$INDEX_FILE"
