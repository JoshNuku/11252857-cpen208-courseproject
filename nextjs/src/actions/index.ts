import axios from "axios";
import bcrypt from "bcryptjs";
import { redirect } from "next/navigation";
import { verifyCredentials } from "@/app/login/page";

export async function SignUp(
  formState: { message: string },
  formData: FormData
) {
  const data = {
    student_id: formData.get("student_id") as string,
    first_name: formData.get("first_name") as string,
    last_name: formData.get("last_name") as string,
    email: formData.get("email") as string,
    level: formData.get("level") as string,
    password: formData.get("password") as string,
  };

  const hash = await bcrypt.hash(data.password, 12);
  if (!hash) return { message: "Something went wrong, refresh and try again" };
  data.password = hash;

  const student = await axios.post(
    "http://localhost:5051/api/add_student",
    data
  );
  if (!student.data.student_id) {
    return {
      message: student.data.replaceAll("\n", ",").split(",")[1].trim(),
    };
  }
  // Sign in the user after successful registration
  const result = await verifyCredentials({
    student_id: student.data.student_id,
    password: formData.get("password") as string,
  });

  console.log(result);
  if (result?.error) {
    return { message: result.error };
  }
  redirect(`/${data.student_id}`);

  //  return { message: "Could not create account refresh and try again" };
}

export async function Login(
  formState: { message: string },
  formData: FormData
) {
  const student_id = formData.get("student_id") as string;
  const password = formData.get("password") as string;
  const result = await verifyCredentials({ student_id, password });

  if (result?.error) {
    return { message: "Wrong student ID or password" };
  }
  return { message: "Credentials approved" };
  //redirect(`/${student_id}`);
}

export async function getRegisteredCourses(id: string) {
  const courses = await axios.get("http://localhost:5051/courses/all_courses");

  const { data: data } = courses.data;
  const courseInfo = data?.flat();

  const regCourses = courseInfo.filter((el: any) => el?.student_id == id);

  const regCoursesInfo = [];
  for (let courses of regCourses) {
    for (let info of data[0]) {
      if (info.course_code == courses.course_code) {
        info.date = courses.reg_date;
        info.img = courses.img;
        regCoursesInfo.push(info);
      }
    }
  }
  return regCoursesInfo;
}

export async function registerCourse(
  course_code: string,
  id: string,
  course_name: string
) {
  const img = await searchPhotos(course_name);
  const course = await axios.post("http://localhost:5051/courses/add_course", {
    student_id: parseInt(id),
    course_code,
    img,
  });
  console.log(course);
}

export async function searchPhotos(query: string) {
  try {
    // Make the API request
    const response = await axios.get(
      `https://pixabay.com/api/?key=16477272-84df86c59f59da088a9d9a790&q=${query}&image_type=photo&pretty=true&per_page=3`
    );
    //console.log(response.data);
    // Process the response data
    const images = response.data.hits.map((photo: any) => {
      return photo.webformatURL;
    });
    console.log(images);
    return images[1];
  } catch (error) {
    console.error(error);
  }
}
