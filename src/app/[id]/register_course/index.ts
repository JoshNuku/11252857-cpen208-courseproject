import axios from "axios";

export async function getAllCourses() {
  try {
    const courses = await axios.get(
      "http://localhost:5051/courses/all_courses"
    );
    console.log(courses.data);
    return courses.data as Array<object>;
  } catch (e) {
    console.log(e);
    return e;
  }
}
