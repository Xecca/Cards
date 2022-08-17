# Cards

## Overview:

Данное приложение является карточной игрой на память, в ходе которой необходимо за наименьшее количество переворотов карт найти все индентичные пары.
[gif]
При начале новой игры карты генерируются случайным образом, создавая пары карт с разными фигурами и их цветами. И также случайным образом располагаются на игровом поле.
Рисунок обратной стороны при каждом создании карты генерируется случайным образом, используя UIBezierPath.
В игре есть возможность продолжить прерванную игру с того места, на котором она была остановлена. Сохранение последнего состояния игры реализовано с использованием технологии CoreData.
На экране Settings можно выбрать количество пар карт, которые будут использоваться в игре. Также там можно выбрать формы фигур и их цвета. Внесенные изменения в игру сохраняются с использованием UserDefaults.
Генерация карт происходит с помощью архитектурного паттерна Фабрика.

## Used frameworks, technologies and methods:

- MVC
- UIKit
- UIBezierPath
- Factory Method Pattern
- CoreData
- UserDefaults
- CoreAnimation

## Coming soon:

- Implement the MVP architectural pattern
- Unit Test (XCTest)
- Previous games scores
- Time spent per party
- Ability to add other images (including custom ones), instead of using random shape generation
- Exclude overlapping cards on each other at the start of the game (while generation)
