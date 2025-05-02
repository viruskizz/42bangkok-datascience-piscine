# 🧠 42 Bangkok Data Science Piscine

Welcome to the **42 Bangkok Data Science Piscine** repository! This project encompasses a series of intensive modules designed to introduce and develop skills in data engineering, warehousing, analysis, and science. Each module builds upon the previous, offering hands-on experience with real-world datasets and tools.

## 📁 Repository Structure

The repository is organized into the following directories:

- `ds00/` – **Data Engineer**
- `ds01/` – **Data Warehouse**
- `ds02/` – **Data Analyst**
- `ds03/` – **Data Scientist 1**
- `ds04/` – **Data Scientist 2**
- `scripts/` – Utility and helper scripts

Each module contains exercises (`ex00`, `ex01`, etc.) that focus on specific tasks and learning objectives.

## 🧰 Technologies Used

- **PostgreSQL** – Relational database management system
- **Docker & Docker Compose** – Containerization and environment management
- **Python** – Data processing and analysis
- **Jupyter Notebook** – Interactive computing environment
- **pgAdmin** – PostgreSQL database management tool

## 🚀 Getting Started

### Prerequisites

- Install [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/)
- Clone this repository:

```bash
git clone https://github.com/viruskizz/42bangkok-datascience-piscine.git
cd 42bangkok-datascience-piscine
```

## 🚀 Setup

1. Copy the sample environment file and configure it as needed:

```bash
cp .env.sample .env
```

2. Build and start the Docker containers:
```bash
docker-compose up --build
```

3. Access:
- pgAdmin: http://localhost:8000?token={JUPYTER_TOKEN}
- Jupyter Notebook: http://localhost:8888

📚 Module Overviews
1. Data Engineer (ds00/)
Set up PostgreSQL using Docker, import CSV data, and automate table creation processes.

2. Data Warehouse (ds01/)
Design and implement data warehousing solutions, including data cleaning, transformation, and integration.

3. Data Analyst (ds02/)
Perform exploratory data analysis (EDA), statistical analyses, and create visualizations to derive insights.

4. Data Scientist 1 (ds03/)
Apply machine learning algorithms for predictive modeling and clustering.

5. Data Scientist 2 (ds04/)
Engage in advanced data science projects, including deep learning and natural language processing.

📝 License
This project is licensed under the MIT License. See the LICENSE file for details.