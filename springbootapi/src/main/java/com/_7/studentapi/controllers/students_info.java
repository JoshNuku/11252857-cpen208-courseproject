package com._7.studentapi.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com._7.studentapi.conn_class.db_config;
import com._7.studentapi.models.students;

@RestController
@RequestMapping("/api")
public class students_info {
     students student = new students();

    @Autowired
    private db_config cls_db_config;

    @CrossOrigin(origins = "*")
    @GetMapping("/all_students")
   public String all_students (){
    
   student.con= cls_db_config.getCon();
   String result = student.select_all_students();

    return result;
   }
   @CrossOrigin(origins = "*")
   @PostMapping("/add_student")
   public String add_course (@RequestBody String json_request){
    
    student.con= cls_db_config.getCon();
  return student.add_new_student(json_request);
}
}
