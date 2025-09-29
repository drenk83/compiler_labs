#!/bin/bash

# Это комментарий: Демонстрация основного синтаксиса Bash

# Переменные
script_name="demo_script"
count=0
array=(элемент1 элемент2 элемент3)  # Массив как пример переменной

# Параметры скрипта
if [ $# -lt 2 ]; then
    echo "Использование: $0 аргумент1 аргумент2"
    exit 1
fi
arg1="$1"
arg2="$2"
echo "Аргументы: $arg1 и $arg2. Всего аргументов: $#"

# Командная подстановка
current_date=$(date +%Y-%m-%d)
echo "Текущая дата: $current_date"

# Функция
function greet {
    local name="$1"  # Локальная переменная
    echo "Привет, $name!"
    return 0
}

# Вызов функции
greet "$arg1"

# Условные конструкции
if [ "$arg1" == "test" ]; then
    echo "Аргумент1 равен 'test'"
elif [ "$arg1" == "hello" ]; then
    echo "Аргумент1 равен 'hello'"
else
    echo "Аргумент1: $arg1 (не test и не hello)"
fi

# Циклы: for
echo "Цикл for по массиву:"
for item in "${array[@]}"; do
    echo "$item"
done

# Цикл while
echo "Цикл while:"
while [ $count -lt 3 ]; do
    echo "Счет: $count"
    ((count++))
done

# Цикл until
count=0
echo "Цикл until:"
until [ $count -ge 3 ]; do
    echo "Счет: $count"
    ((count++))
done

# Перенаправление ввода/вывода
echo "Запись в файл output.txt" > output.txt
echo "Дозапись в файл" >> output.txt
cat < output.txt  # Ввод из файла

# Ошибки
nonexistent_command 2> error.log || echo "Ошибка записана в error.log"

# Пайпы и цепочки команд
echo "Пайп: Список файлов | сортировка"
ls | sort

# Цепочки: Успех && или неудача ||
true && echo "Успех: true выполнено"
false || echo "Неудача: false, но || сработало"

# Специальные символы и экранирование
echo "Двойные кавычки: Разрешают \$VAR: $script_name"
echo 'Одиночные кавычки: Не разрешают $VAR'
echo "Экранирование: \$ буквальный доллар"
echo "Подстановки: Файлы с расширением .txt: *.txt"
echo "Один символ: Файлы с одним символом перед .txt: ?.txt"

# Завершение
echo "Скрипт завершен. PID: $$"