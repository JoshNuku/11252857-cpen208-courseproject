import NextAuth, { NextAuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import axios from "axios";
import bcrypt from "bcryptjs";

export const authOptions: NextAuthOptions = {
  session: {
    maxAge: 5 * 60,
  },
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
        console.log(student);
        if (!student) {
          throw new Error("Wrong Student ID or password");
        }
        console.log(credentials);
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
          level: student.level.toString(),
        };
      },
    }),
  ],
  secret: "SWAo+SrFXMRVhRbA4SI2OEHd+NQ7/V9lG6g8WSkc+54=",
  pages: {
    signIn: "/login",
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.level = user.level;
      }
      return token;
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string;
        session.user.level = token.level as string;
      }
      return session;
    },
  },
};

const handler = NextAuth(authOptions);
export { handler as GET, handler as POST };
