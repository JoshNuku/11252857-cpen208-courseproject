/* eslint-disable @next/next/no-async-client-component */
"use client";
import { getRegisteredCourses, registerCourse } from "@/actions";
import Footer from "@/app/components/footer";
import Navbar from "@/app/components/navbar";
import Select_course, { ButtonOrMessage } from "@/app/components/select_course";
import axios from "axios";
import { useSession } from "next-auth/react";
import { useRouter } from "next/navigation";
import { JSX, useEffect, useState } from "react";

let selectedCourses: any[] = [];
let NumOfSelectedCourses = 0;

export default async function RegisterCourse(props: {
  params: { id: string };
}) {
  const user = useSession();
  const router = useRouter();
  const [message, setMessage] = useState("");

  const { data: session, status } = user;
  if (!(status === "authenticated") || session.user.id !== props.params.id)
    return router.push("/id/404");

  const courses = await axios.get("http://localhost:5051/courses/all_courses");

  const { data: data } = courses.data;

  const handleCheckboxClick = (data: any, isSelected: boolean) => {
    if (isSelected) {
      selectedCourses.push(data);
      NumOfSelectedCourses++;
    } else {
      const index = selectedCourses.indexOf(data);
      selectedCourses.splice(index, 1);
      if (NumOfSelectedCourses) NumOfSelectedCourses--;
    }

    console.log(selectedCourses, NumOfSelectedCourses);
  };

  const handleRegisterSubmit = (e: any) => {
    e.preventDefault();
    if (selectedCourses.length <= 6 && selectedCourses.length > 0) {
      selectedCourses.forEach((course) => {
        registerCourse(course.course_code, props.params.id, course.course_name);
      });

      router.push(`/${props.params.id}`);
      selectedCourses = [];
      NumOfSelectedCourses = 0;
    }
    if (!selectedCourses.length)
      setMessage("Select at least one course to register");
    if (selectedCourses.length > 6)
      setMessage("Cannot select more than six courses");
  };

  async function displayCourses() {
    const arr: JSX.Element[] = [];
    const courseInfo = data[0].filter(
      (course: any) => course.level == user.data?.user.level
    );
    const reg_courses = await getRegisteredCourses(props.params.id);
    reg_courses.forEach((course: any) => delete course.date);
    console.log(reg_courses, courseInfo);
    for (let course of reg_courses) {
      courseInfo.forEach((reg: any) => {
        if (reg.course_code == course.course_code) {
          const index = courseInfo.indexOf(reg);

          courseInfo.splice(index, 1);
        }
      });

      if (!reg_courses.length)
        arr.push(
          <Select_course props={course} onCheckboxClick={handleCheckboxClick} />
        );
    }

    courseInfo.forEach((course: any) => {
      arr.push(
        <Select_course props={course} onCheckboxClick={handleCheckboxClick} />
      );
    });
    return arr;
  }

  return (
    <div>
      <Navbar id={props.params.id} />
      <div className="mt-10 flex-grow h-screen">
        <form
          className="bg-gray-50 dark:bg-gray-900 p-3 sm:p-5 antialiased flex-grow"
          onSubmit={handleRegisterSubmit}
        >
          <div className="mx-auto max-w-screen-2xl px-4 lg:px-12 flex-grow">
            {message ? (
              <div className="my-3 p-3 bg-red-200 rounded border-red-600 text-center">
                {message}
              </div>
            ) : null}
            <div className="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg overflow-hidden rounded-lg">
              <div className="flex flex-col md:flex-row md:items-center md:justify-between space-y-3 md:space-y-0 md:space-x-4 p-4">
                <div className="flex-1 flex items-center space-x-2">
                  <h5>
                    <span className="text-black dark:text-white">
                      All Courses
                    </span>
                  </h5>
                </div>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                  <thead className="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                    <tr>
                      <th scope="col" className="p-4">
                        <div className="flex items-center"></div>
                      </th>
                      <th scope="col" className="p-4">
                        Course
                      </th>
                      <th scope="col" className="p-4">
                        Course Code
                      </th>
                      <th scope="col" className="p-4">
                        Credit Hours
                      </th>
                      <th scope="col" className="p-4">
                        Lecturer
                      </th>
                      <th scope="col" className="p-4">
                        TA
                      </th>
                    </tr>
                  </thead>
                  {displayCourses()}
                </table>
              </div>
            </div>

            <button className="flex items-center justify-center text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-primary-600 dark:hover:bg-primary-700 focus:outline-none dark:focus:ring-primary-800 mt-5 ms-5">
              Register
            </button>
          </div>
        </form>
      </div>
      <Footer />
    </div>
  );
}
