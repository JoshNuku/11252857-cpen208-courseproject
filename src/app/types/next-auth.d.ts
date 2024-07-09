import NextAuth from "next-auth";

declare module "next-auth" {
  interface Session {
    user: {
      level: string;
      id: string;
      name: string;
      email: string;
    };
  }
  interface User {
    level: string;
  }
}
