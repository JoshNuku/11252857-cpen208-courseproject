package com._7.studentapi.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com._7.studentapi.conn_class.db_config;
import com._7.studentapi.models.finances;

@RestController
@RequestMapping("/finances")
public class finances_info {
    finances fees = new finances();
     @Autowired
    private db_config cls_db_config;

    @CrossOrigin(origins = "*")
    @GetMapping("/outstanding_fees")
    public String outstanding_fees(){
        
        fees.con = cls_db_config.getCon();
        String result = fees.get_outstanding_fees();
        return result;
    }


}
