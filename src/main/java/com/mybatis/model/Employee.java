package com.mybatis.model;

import java.io.Serializable;

/**
 * Created by DJ on 2017/6/25.
 */
public class Employee implements Serializable{
    private static final long serialVersionUID = 1L;
    private Integer id;
    private String lastName;
    private String email;

    public int getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    @Override
    public String toString() {
        return "Employee [id=" + id + ", lastName=" + lastName + ", email="
                + email+" ]" ;
    }
    public Employee(){}
}