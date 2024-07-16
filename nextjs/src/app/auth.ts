import NextAuth from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import axios from "axios";
import bcrypt from "bcryptjs";

export const authOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        student_id: { label: "Student ID", type: "text" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials?.student_id || !credentials?.password) {
          return null;
        }

        const { data } = await axios.get(
          "http://localhost:5051/api/all_students"
        );
        const allStudents = data.data;
        const student = allStudents.find(
          (stu: any) => stu.student_id == parseInt(credentials.student_id)
        );

        if (!student) {
          throw new Error("Student ID does not exist");
        }

        const match = await bcrypt.compare(
          credentials.password,
          student.password
        );
        if (!match) {
          throw new Error("Wrong Student ID or password");
        }

        return {
          id: student.student_id.toString(),
          name: `${student.first_name} ${student.last_name}`,
          email: student.email,
          level: student.level,
        };
      },
    }),
  ],
  pages: {
    signIn: "/login",
  },
  callbacks: {
    async jwt({ token, user }: any) {
      if (user) {
        token.id = user.id;
      }
      return token;
    },
    async session({ session, token }: any) {
      if (session.user) {
        session.user.id = token.id as string;
      }
      return session;
    },
  },
};
