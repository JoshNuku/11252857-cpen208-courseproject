"use client";
import { signOut } from "next-auth/react";

export default function Footer() {
  return (
    <footer className="bg-white rounded-lg shadow m-2 dark:bg-gray-800 oinset-x-0 bottom-0">
      <div className="w-full mx-auto max-w-screen-xl p-4 md:flex md:items-center md:justify-between">
        <span className="text-sm text-gray-500 sm:text-center dark:text-gray-400">
          © 2024{" "}
          <a href="/" className="hover:underline">
            Computer Engineering Department
          </a>
          . All Rights Reserved.
        </span>
        <ul className="flex flex-wrap items-center mt-3 text-sm font-medium text-gray-500 dark:text-gray-400 sm:mt-0">
          <li>
            <a href="/" className="hover:underline me-4 md:me-6">
              Home
            </a>
          </li>

          <li>
            <a
              onClick={async function handleLogout() {
                await signOut({ callbackUrl: "http://localhost:3000/login" });
              }}
              className="hover:underline"
            >
              Logout
            </a>
          </li>
        </ul>
      </div>
    </footer>
  );
}
