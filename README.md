# App de Clima 🌤️ (Weather App)

<p align="center">
  <img src="https://github.com/EderJrDev/Weater-App/blob/main/projectImages/weaterApp-moon.png" alt="Modo Dia" width="800">
<!--   <img src="https://raw.githubusercontent.com/EderJrDev/Weater-App/main/projectImages/weaterApp-moon.png" alt="Modo Noite" width="300"> -->
</p>

## 📖 Sobre

Este é um aplicativo de previsão do tempo para iOS, desenvolvido como um projeto de portfólio para demonstrar habilidades em desenvolvimento nativo com Swift. O objetivo principal foi aplicar as melhores práticas do mercado, incluindo uma arquitetura limpa, componentização e código testável, seguindo os requisitos de vagas para desenvolvedores iOS.

O aplicativo exibe as condições climáticas atuais, a previsão para as próximas horas e para os próximos dias de uma cidade pré-definida.

---

## ✨ Features

* **Clima Atual:** Exibe a temperatura, nome da cidade, umidade e velocidade do vento.
* **Background Dinâmico:** A imagem de fundo muda automaticamente entre dia e noite.
* **Ícones Dinâmicos:** O ícone principal de clima se adapta para sol (dia) ou lua (noite).
* **Previsão por Hora:** Uma `UICollectionView` horizontal mostra a previsão para as próximas horas.
* **Previsão Diária:** Uma `UITableView` vertical lista a previsão com temperaturas mínimas e máximas para os próximos dias.

---

## 🚀 Tecnologias e Boas Práticas Aplicadas

Este projeto foi cuidadosamente construído para servir como um exemplo prático de um aplicativo iOS moderno e bem arquitetado.

* **Linguagem:** **Swift**
* **Interface (UI):** **View Code** com Auto Layout. Toda a interface foi construída programaticamente, sem o uso de Storyboards ou XIBs, demonstrando proficiência na criação de layouts flexíveis e manuteníveis.
* **Arquitetura:** **MVVM (Model-View-ViewModel)**.
    * **Model:** `Structs` simples e `Codable` que representam os dados da API.
    * **View (`ViewController`):** Responsável apenas por exibir a UI e delegar ações. Ela é "reativa" e se atualiza conforme os dados do ViewModel mudam.
    * **ViewModel (`WeatherViewModel`):** Contém toda a lógica de negócio, formatação de dados e gerencia o estado da View. Ele atua como uma ponte entre o Model e a View.
* **Princípios SOLID:**
    * **SRP (Single Responsibility Principle):** Cada classe tem uma responsabilidade única (a `ViewController` cuida da UI, o `ViewModel` da lógica, o `Service` da comunicação com a API).
* **Padrões de Projeto (Design Patterns):**
    * **Delegate & DataSource:** Utilizados para gerenciar a `UICollectionView` e a `UITableView`.
    * **Observer (via Closures):** O `ViewController` "observa" o `ViewModel` através de uma closure (`onDataUpdate`) para saber quando precisa se atualizar.
* **Injeção de Dependência (Dependency Injection):** O `ViewModel` recebe suas dependências (como o `Service`) através de seu inicializador, o que desacopla o código e facilita a criação de testes unitários.
* **Comunicação com API:** Uso de `URLSession` para realizar requisições de rede de forma assíncrona para a API da [OpenWeatherMap](https://openweathermap.org/api).
* **Componentização:** Criação de células customizadas e reutilizáveis (`DailyForecastTableViewCell` e `HouryForecastCollectionViewCell`), análogas aos componentes em frameworks como React.

---

## 📂 Estrutura do Projeto

O projeto está organizado com uma separação clara de responsabilidades para facilitar a navegação e manutenção:

```
Weater App/
│
├── 📁 Application/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
│
├── 📁 Models/
│   ├── City.swift
│   ├── CurrentWeatherData.swift
│   └── ForecastData.swift
│
├── 📁 ViewModels/
│   └── WeatherViewModel.swift
│
├── 📁 Views/
│   ├── ViewController.swift
│   ├── DailyForecastTableViewCell.swift
│   └── HouryForecastCollectionViewCell.swift
│
├── 📁 Services/
│   └── Service.swift
│
└── 📁 Extensions/
    ├── Color+Extensions.swift
    └── Core+Extensions.swift
```

## 🔮 Próximos Passos

* [ ] Implementar uma tela de busca para que o usuário possa escolher a cidade.
* [ ] Escrever Testes Unitários para o `WeatherViewModel` para garantir a lógica de formatação de dados.
* [ ] Adicionar tratamento de erros mais robusto para exibir mensagens ao usuário (ex: falha na conexão).
* [ ] Mapear todos os ícones de clima fornecidos pela API.
