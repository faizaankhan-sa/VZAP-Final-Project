/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.util.List;

/**
 *
 * @author Jarrod
 */
public class Table {
    private String tableName;
    private List<String> columns;
    private List<List<String>> data;
    private Integer numberOfRows;
    
    public Table() {
    }

    public Table(String tableName, Integer numberOfRows,List<String> columns, List<List<String>> data) {
        this.tableName = tableName;
        this.columns = columns;
        this.data = data;
        this.numberOfRows = numberOfRows;
    }
    
    public List<String> getColumns() {
        return columns;
    }

    public void setColumns(List<String> headers) {
        this.columns = headers;
    }

    public List<List<String>> getData() {
        return data;
    }

    public void setData(List<List<String>> data) {
        this.data = data;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public Integer getNumberOfRows() {
        return numberOfRows;
    }

    public void setNumberOfRows(Integer numberOfRows) {
        this.numberOfRows = numberOfRows;
    }
    
    @Override
    public String toString() {
        return "Table{" + "tableName=" + tableName + ", columns=" + columns + ", data=" + data + ", numberOfRows=" + numberOfRows + '}';
    }
}
