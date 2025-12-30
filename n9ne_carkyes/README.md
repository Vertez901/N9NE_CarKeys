# 🗝️ n9ne_carkyes

Advanced item-based car key system for RedM/FiveM using **ox_inventory** and **ox_lib**.

---

## 📖 Wstęp

**n9ne_carkyes** to profesjonalny skrypt na kluczyki samochodowe, który integruje się bezpośrednio z ekwipunkiem gracza. Klucze nie są przypisane "do konta", ale są fizycznymi przedmiotami z metadanymi, co pozwala na ich kradzież, przekazywanie lub przechowywanie w schowkach.

### Główne cechy:
*   ✅ **Fizyczne itemy:** Każdy klucz posiada unikalną rejestrację (`plate`) w metadanych.
*   ✅ **Zarządzanie silnikiem:** Silnik nie odpali automatycznie bez posiadania odpowiedniego klucza.
*   ✅ **Hotwire System:** Możliwość odpalenia pojazdu "na krótko" za pomocą minigierki.
*   ✅ **Pełna synchronizacja:** Obsługa blokady drzwi, świateł oraz animacji pilota.

---

## ⚙️ Wymagania

Do poprawnego działania skryptu wymagane są następujące zasoby:
*   [es_extended](https://github.com/esx-framework/esx_core) (ESX Legacy)
*   [ox_inventory](https://github.com/overextended/ox_inventory)
*   [ox_lib](https://github.com/overextended/ox_lib)

---

## 🚀 Instalacja

1. Pobierz paczkę i umieść folder `n9ne_carkyes` w katalogu `resources`.
2. Dodaj `ensure n9ne_carkyes` do pliku `server.cfg` (po `ox_inventory` i `ox_lib`).
3. Skonfiguruj przedmiot w ekwipunku (patrz niżej).

### Konfiguracja przedmiotu (`ox_inventory`)
Dodaj poniższy kod do pliku `ox_inventory/data/items.lua`:

```lua
['carkey'] = {
    label = 'Kluczyki',
    weight = 10,
    stack = false,
    close = true,
    description = 'Kluczyki do pojazdu: %s', -- Opcjonalne: wyświetla rejestrację w opisie
},
```

---

## 🛠️ Konfiguracja (config.lua)

Skrypt pozwala na łatwą zmianę klawiszy oraz powiadomień. Poniżej najważniejsze opcje:

| Opcja | Opis |
| :--- | :--- |
| `Config.Keybind` | Klawisz do otwierania/zamykania drzwi (domyślnie `U`). |
| `Config.EngineKeybind` | Klawisz do włączania/wyłączania silnika (domyślnie `Y`). |
| `Config.ItemName` | Nazwa techniczna przedmiotu w inventory. |
| `Config.Hotwire` | Ustawienia czasu, trudności i szansy na alarm podczas kradzieży. |

---

## 💻 API dla Deweloperów (Exports)

Możesz łatwo zintegrować `n9ne_carkyes` ze swoim salonem samochodowym lub systemem prac.

### Nadawanie klucza (`GiveKey`)
Generuje przedmiot klucza dla gracza.

| Parametr | Typ | Opis |
| :--- | :--- | :--- |
| `playerId` | `number` | ID serwerowe gracza. |
| `plate` | `string` | Tablica rejestracyjna pojazdu. |
| `modelName` | `string` | (Opcjonalnie) Nazwa/Model pojazdu do opisu. |

```lua
-- Server Side
exports.n9ne_carkyes:GiveKey(source, 'ABC 123', 'Adder')
```

### Usuwanie klucza (`RemoveKey`)
Usuwa klucz powiązany z konkretną rejestracją.

```lua
-- Server Side
exports.n9ne_carkyes:RemoveKey(source, 'ABC 123')
```

### Sprawdzanie posiadania klucza (`HasKeys`)
Zwraca `true` lub `false`.

```lua
-- Server Side
local hasKey = exports.n9ne_carkyes:HasKeys(source, 'ABC 123')
```

---

## ⌨️ Komendy

| Komenda | Uprawnienia | Opis |
| :--- | :--- | :--- |
| `/givekey [plate]` | Admin | Nadaje klucz do podanej rejestracji lub aktualnego pojazdu. |

---

> 💡 **Wskazówka:** Jeśli używasz `ox_target`, możesz łatwo dodać opcję "Otwórz/Zamknij" do menu kołowego, wywołując exporty klienta.
