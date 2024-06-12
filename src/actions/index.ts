"use server";
import axios from "axios";
const bcrypt = require("bcrypt");
import { redirect } from "next/navigation";

export async function SignUp(
  formState: { message: string },
  formData: FormData
) {
  console.log(formData);
  const data = {
    student_id: formData.get("student_id") as string,
    first_name: formData.get("first_name") as string,
    last_name: formData.get("last_name") as string,
    email: formData.get("email") as string,
    level: formData.get("level") as string,
    hash: formData.get("password") as string,
  };
  try {
    // if (typeof data.student_id !== "string") return { message: "" };
    await bcrypt.hash(data.hash, 12, async function (err: Error, hash: string) {
      data.hash = hash;
      console.log(data.hash, hash);
      // const student = await axios.post(
      //   "http://localhost:5050/api/students",
      //   data
      // );
      // if (!student) return { message: "Could not create account" };
      // console.log(student);
    });
  } catch (e) {
    console.log(e);
  }
  if (!data.student_id) return { message: "Could not create account" };
  redirect(`/${data.student_id}`);
}

export async function Login(
  formState: { message: string },
  formData: FormData
) {
  const student_id = formData.get("student_id") as string;
  if (!student_id) return { message: "Could not create account" };
  redirect(`/${student_id}`);
}
