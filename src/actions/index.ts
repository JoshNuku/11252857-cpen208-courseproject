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
  try {
    const hash = await bcrypt.hash(data.password, 12);
    if (!hash)
      return { message: "Something went wrong, refresh and try again" };
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
  } catch (e) {
    return { message: "Could not create account refresh and try again" };
  }
  redirect(`/${data.student_id}`);
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
