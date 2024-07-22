package com._7.studentapi.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com._7.studentapi.conn_class.db_config;
import com._7.studentapi.models.courses;
@RestController
@RequestMapping("/courses")


public class courses_info {
    

     courses course = new courses();

    @Autowired
    private db_config cls_db_config;

     
    @GetMapping("/all_courses")
    @CrossOrigin(origins = "*")
   public String all_courses (){
    
  course.con= cls_db_config.getCon();
   String result =course.select_all_courses_and_registrations();

    return result;
   }

   @PostMapping("/add_course")
   @CrossOrigin(origins = "*")
   public String add_course (@RequestBody String json_request){
    
    course.con= cls_db_config.getCon();
  return course.add_new_course(json_request);
}
}

