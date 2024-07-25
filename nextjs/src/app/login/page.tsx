/* eslint-disable @next/next/no-async-client-component */
/* eslint-disable react/no-unescaped-entities */
"use client";

//import { Login } from "@/actions";
import { Alert } from "flowbite-react";
import { useFormState } from "react-dom";

import { useRouter } from "next/navigation";
import { signIn, useSession } from "next-auth/react";
import { Login } from "@/actions";
import { useState } from "react";

export function verifyCredentials({ student_id, password }: any) {
  const result = signIn("credentials", {
    student_id,
    password,
    redirect: false,
  });
  return result;
}
export default function LoginPage() {
  const router = useRouter();
  const user = useSession();
  const [formState, action] = useFormState(Login, { message: "" });
  const [show, setShow] = useState(true);
  let message = "";
  function handleDismiss() {
    message = "";
  }

  const { data: session, status } = user;

  if (status === "authenticated") {
    message = "Logged you in";
    return router.push(`/${session.user.id}`);
  }
  if (status == "unauthenticated") {
    message = "Not Logged In";
  }
  return (
    <section
      className="flex justify-center items-center bg-no-repeat bg-cover bg-center bg-gray-700 bg-blend-multiply h-screen"
      style={{
        backgroundImage:
          "url('https://images.pexels.com/photos/1416367/pexels-photo-1416367.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')",
      }}
    >
      <div className="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
        <a
          href="/"
          className="flex items-center mb-4 text-xl font-semibold text-gray-900 text-white mt-10 border rounded-lg  p-5"
        >
          Computer Engineering Department
        </a>
        {message ? (
          message || formState.message ? (
            <Alert color="failure" className="m-2">
              {formState.message || message}
            </Alert>
          ) : null
        ) : null}
        <div className="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
          <div className="p-6 space-y-4 md:space-y-6 sm:p-8">
            <h1 className="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
              Sign in to your account
            </h1>
            <form className="space-y-4 md:space-y-6" action={action}>
              <div>
                <label
                  htmlFor="ID"
                  className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Your Student ID
                </label>
                <input
                  type="number"
                  name="student_id"
                  id="ID"
                  className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  placeholder="12345678"
                  required
                />
              </div>
              <div>
                <label
                  htmlFor="password"
                  className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Password
                </label>
                <input
                  type="password"
                  name="password"
                  id="password"
                  className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  required
                />
              </div>

              <button
                type="submit"
                className="w-full text-white bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
                // onClick={handleDismiss}
              >
                Sign in
              </button>
              <p className="text-sm font-light text-gray-500 dark:text-gray-400">
                Don't have an account yet?{" "}
                <a
                  href="/register"
                  className="font-medium text-primary-600 hover:underline dark:text-primary-500"
                >
                  Register
                </a>
              </p>
            </form>
          </div>
        </div>
      </div>
    </section>
  );
}
