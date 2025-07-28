# Bash Database Management System (DBMS)

**A complete Database Management System implemented in Bash scripting language, featuring a user-friendly terminal interface with dynamic layout adaptation**

---

## 🌟 Features (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧

### Database Operations

- **Create Database**: Create new databases with validation
- **List Databases**: View all available databases in a numbered list
- **Connect to Database**: Access and manage tables within a database
- **Drop Database**: Delete databases with confirmation prompts

### Table Operations

- **Create Tables**: Define table structure with columns and data types
- **Update Table Metadata**: Modify column definitions, add/remove columns
- **List Tables**: Display all tables in the current database
- **Drop Tables**: Delete tables with data protection confirmations

### Data Operations

- **Insert Data**: Add records with type validation and primary key constraints
- **Select Data**: Query records with search functionality (global or column-specific)
- **Update Data**: Modify existing records with validation
- **Delete Data**: Remove records with selective deletion options

### Advanced Features

- **Primary Key Support**: Automatic uniqueness validation
- **Data Type Validation**: Support for `int` and `string` types
- **Responsive UI**: Dynamic layout that adapts to terminal size
- **Search Functionality**: Case-insensitive search across tables or specific columns
- **Formatted Output**: Beautiful table display with borders and alignment

---

## 🚀 Getting Started

### Prerequisites

- Bash shell (version 4.0 or higher)
- Linux/Unix environment or Windows with WSL
- Terminal with standard utilities (`tput`, `sed`, `grep`, `cut`, etc.)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/Bash-DBMS-An-ITI-Project.git
   cd Bash-DBMS-An-ITI-Project
   ```

2. Make the main script executable:

   ```bash
   chmod +x DBMS.sh
   ```

3. Run the application:

   ```bash
   ./DBMS.sh
   ```

---

## 📁 Project Structure

```bash
Bash-DBMS-An-ITI-Project/
├── DBMS.sh                 # Main entry point
├── database_functions.sh   # Database-level operations
├── table_main_menu.sh      # Table management interface
├── table_functions.sh      # Table and data operations
├── DataBases/              # Directory for database storage
└── README.md               # This file
```

---

## 🎯 Usage Examples

### Creating a Database

1. Run `./DBMS.sh`
2. Select option `1` (Create Database)
3. Enter a valid database name (must start with letter, contain only letters, digits, underscores)

### Creating a Table

1. Connect to a database (option 3)
2. Select `1` (Create Table)
3. Enter table name and number of columns
4. Define each column with name, type, and optional primary key

### Inserting Data

```bash
# Example table structure:
# users.meta:
# id:int:PK
# name:string
# email:string

# Data insertion will prompt for:
# - id (Primary Key, integer)
# - name (string)
# - email (string)
```

### Searching Data

- **Global search**: Search across all columns
- **Column-specific search**: Search within a particular column
- **Case-insensitive**: Matches regardless of case

---

## 🏗️ Architecture

### File Organization

- **DBMS.sh**: Main menu and application entry point
- **database_functions.sh**: Database CRUD operations
- **table_main_menu.sh**: Table-specific user interface
- **table_functions.sh**: Table structure and data management

### Data Storage

- **Databases**: Stored as directories in `./DataBases/`
- **Tables**: Two files per table:
  - `.meta`: Column definitions (format: `column_name:type[:PK]`)
  - `.data`: Actual data (format: `value1:value2:value3`)

### Key Functions

#### CenteredPrint()

Dynamic text centering that adapts to terminal width:

```bash
CenteredPrint "Your text here"
```

#### Data Validation

- **Name validation**: `^[a-zA-Z][a-zA-Z0-9_]*$` pattern
- **Type checking**: Integer and string validation
- **Primary key constraints**: Uniqueness enforcement

---

## 🎨 User Interface Features

### Responsive Design

- **Dynamic width calculation**: Uses `tput cols` for terminal width
- **Centered layouts**: All menus and content center automatically
- **Bordered displays**: Beautiful ASCII borders that scale with content

### User Experience

- **Confirmation prompts**: Destructive operations require confirmation
- **Error handling**: Clear error messages with cute emoticons
- **Navigation**: Intuitive menu systems with numbered options
- **Visual feedback**: Success/error messages with Japanese emoticons

---

## 🔧 Technical Details

### Data Types

- **int**: Positive integers only (`^[0-9]+$`)
- **string**: Non-empty text values

### Constraints

- **Primary Keys**: Automatically validated for uniqueness
- **Required Fields**: Empty values rejected for string fields
- **Type Safety**: Data type conversion restrictions (string→int blocked)

### File Operations

- **Metadata Management**: Column definitions in `.meta` files
- **Data Integrity**: Atomic operations with validation
- **Search Optimization**: Efficient grep and sed operations

---

## 🚦 Error Handling

The system includes comprehensive error handling for:

- Invalid database/table names
- Duplicate primary keys
- Type mismatches
- File system errors
- Invalid user input

---

## 🤝 Contributing

This project was created as part of ITI (Information Technology Institute) DevOps training. Contributions are welcome!

### Development Guidelines

- Follow existing code style and conventions
- Add error handling for new features
- Maintain responsive UI design
- Include user-friendly error messages

---

## 📝 License

This project is part of an educational initiative at ITI for DevOps training.

---

## 👥 Authors

- **Abdelrahman Bebars** - Initial development
- **Muhammad Gad** - Initial development
- **ITI DevOps Training Program** - Project framework

---

## 🐛 Known Issues

- Primary key modification restrictions in table updates
- Very Large or Small terminal width may cause formatting issues
- Windows compatibility requires WSL or similar bash environment

---

## 🔮 Future Enhancements

- [ ] Add more data types (float, date, boolean)
- [ ] Implement table relationships (foreign keys)
- [ ] Add data export/import functionality
- [ ] Create backup and restore features
- [ ] Add SQL-like query syntax
- [ ] Implement user authentication
- [ ] Add logging and audit trails

### But they remain "For The Future (╯°□°）╯︵ ┻━┻" :D

---

**Note** This is an educational project demonstrating bash scripting capabilities for database management. For production use, consider established database systems like MySQL, PostgreSQL,...etc

```bash
This README was written with the help of Claude Sonnet 4
```


## Thank you for Reading (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧

---
