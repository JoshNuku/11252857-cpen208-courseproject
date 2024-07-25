/* eslint-disable react/no-unescaped-entities */
"use client";
import { useFormState } from "react-dom";
import { SignUp } from "@/actions";

import Link from "next/link";
import { Alert } from "flowbite-react";
import { useState } from "react";

export default function RegisterPage() {
  const [formState, action] = useFormState(SignUp, { message: "" });
  const [show, setShow] = useState(false);
  function handleDismiss() {
    const res = !show;
    setShow(res);
  }

  return (
    <section
      className="flex justify-center items-center bg-no-repeat bg-cover bg-center bg-gray-700 bg-blend-multiply md:h-screen"
      style={{
        backgroundImage:
          "url('https://images.pexels.com/photos/1509534/pexels-photo-1509534.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')",
      }}
    >
      <div className="flex flex-col items-center justify-center px-4 py-6 mx-auto lg:py-0">
        <a
          href="/"
          className="flex items-center mb-4 text-xl font-semibold text-white mt-10 border rounded-lg  p-5"
        >
          Computer Engineering Department
        </a>
        {show ? (
          formState.message ? (
            <Alert color="failure" className="m-2" onDismiss={handleDismiss}>
              {formState.message}
            </Alert>
          ) : null
        ) : null}
        <div className="bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-sm xl:p-0 dark:bg-gray-800 dark:border-gray-700 m-12">
          <div className="space-y-4 md:space-y-5 sm:p-6 p-5">
            <h1 className="text-lg text-center font-bold leading-tight tracking-tight text-gray-900 md:text-xl dark:text-white">
              Create an account
            </h1>
            <form className="space-y-3 md:space-y-4" action={action}>
              <div className="grid gap-2 md:grid-cols-2 ">
                <div>
                  <label
                    htmlFor="firstname"
                    className="block mb-1 text-sm font-medium text-gray-900 dark:text-white"
                  >
                    First Name
                  </label>
                  <input
                    type="text"
                    name="first_name"
                    id="firstname"
                    className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 w-full p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                    required
                  />
                </div>
                <div>
                  <label
                    htmlFor="lastname"
                    className="block mb-1 text-sm font-medium text-gray-900 dark:text-white"
                  >
                    Lastname
                  </label>
                  <input
                    type="text"
                    name="last_name"
                    id="lastname"
                    className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                    required
                  />
                </div>
              </div>
              <div className="grid gap-2 md:grid-cols-2">
                <div>
                  <label
                    htmlFor="student_id"
                    className="block mb-1 text-sm font-medium text-gray-900 dark:text-white"
                  >
                    Student ID
                  </label>
                  <input
                    type="number"
                    name="student_id"
                    id="student_id"
                    className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                    required
                  />
                </div>
                <div>
                  <label
                    htmlFor="level"
                    className="block mb-1 text-sm font-medium text-gray-900 dark:text-white"
                  >
                    Level
                  </label>
                  <select
                    name="level"
                    id="level"
                    className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                    required
                  >
                    <option value={100}>100</option>
                    <option value={200}>200</option>
                    <option value={300}>300</option>
                    <option value={400}>400</option>
                  </select>
                </div>
              </div>
              <div>
                <label
                  htmlFor="email"
                  className="block mb-1 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Email
                </label>
                <input
                  type="email"
                  name="email"
                  id="email"
                  className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  required
                />
              </div>
              <div>
                <label
                  htmlFor="password"
                  className="block mb-1 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Password
                </label>
                <input
                  type="password"
                  name="password"
                  id="password"
                  className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  required
                />
              </div>
              <button
                type="submit"
                className="w-full text-white bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-4 py-2 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
                onClick={handleDismiss}
              >
                Register
              </button>
              <p className="text-sm text-center font-light text-gray-500 dark:text-gray-400">
                Already have an account?{" "}
                <Link
                  href="/login"
                  className="font-medium text-primary-600 hover:underline dark:text-primary-500"
                >
                  Login
                </Link>
              </p>
            </form>
          </div>
        </div>
      </div>
    </section>
  );
}
