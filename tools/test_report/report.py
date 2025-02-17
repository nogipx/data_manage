import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Читаем CSV файл
import os


script_dir = os.path.dirname(os.path.abspath(__file__))
df = pd.read_csv(os.path.join(script_dir, 'report.csv'))

# Группируем данные по Group и вычисляем средние значения метрик
grouped = df.groupby('Group')[['Protection', 'Refactoring', 'Feedback', 'Maintenance']].mean()

# Создаем фигуру с нужными размерами
plt.figure(figsize=(12, 8))

# Создаем позиции для групп на оси X
x = np.arange(len(grouped.index))
width = 0.1  # ширина столбца

# Создаем столбцы для каждой метрики
plt.bar(x - width, grouped['Protection'], width, label='Защита от багов', color='#2ecc71')
plt.bar(x, grouped['Refactoring'], width, label='Устойчивость к рефакторингу', color='#3498db')
plt.bar(x + width, grouped['Feedback'], width, label='Скорость обратной связи', color='#e74c3c')
plt.bar(x + 2*width, grouped['Maintenance'], width, label='Простота поддержки', color='#f1c40f')

# Настраиваем внешний вид графика
plt.xlabel('Группы тестов')
plt.ylabel('Оценка (0-1)')
plt.title('Анализ качества тестов по группам\nна основе ключевых метрик', pad=20)
plt.xticks(x, grouped.index, rotation=45, ha='right')
plt.grid(True, axis='y', linestyle='--', alpha=0.7)
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=4)

# Устанавливаем пределы осей и отступы
plt.ylim(0, 1)
plt.tight_layout()

# Добавляем аннотацию из книги
plt.figtext(0.02, 0.02, 
            'На основе "Unit Test Principles":\nТест точен, если он выдает хороший сигнал (способен находить ошибки)\n'
            'с минимально возможным шумом (не выдает ложных срабатываний)',
            fontsize=8, alpha=0.7)

plt.show()