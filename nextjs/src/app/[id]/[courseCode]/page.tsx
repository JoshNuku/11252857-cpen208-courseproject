import { notFound, redirect } from "next/navigation";
import Card2, { cardProps } from "../../components/card2";
import Footer from "../../components/footer";
import Navbar from "../../components/navbar";
import { getRegisteredCourses } from "@/actions";
import { CiMap } from "react-icons/ci";
import { GoCommentDiscussion } from "react-icons/go";
import { FaRegNoteSticky } from "react-icons/fa6";
import { CiFolderOn } from "react-icons/ci";

export async function displayCourses(
  Card: any,
  id: string,
  courseCode: string | null
) {
  const courses = await getRegisteredCourses(id);
  console.log(courses);
  if (
    courseCode &&
    !(
      courseCode?.startsWith("CPEN") ||
      courseCode?.startsWith("SENG") ||
      courseCode?.startsWith("CBAS")
    )
  )
    notFound();

  return courses.map((props: cardProps) => {
    const card = (
      <Card
        key={props.course_code}
        course_code={props.course_code}
        course_name={props.course_name}
        credits={props.credits}
        course_info={props.course_info}
        lecturer={props.lecturer}
        ta={props.ta}
        date={props.date}
        level={props.level}
        id={id}
        img={props.img}
      />
    );
    if (courseCode == props.course_code.replace(" ", "")) return card;
    if (!courseCode) return card;
  });
}

export default async function course_info(props: {
  params: { id: string; courseCode: string };
}) {
  console.log(props.params);

  /* const courses = await axios.get("http://localhost:5051/courses/all_courses");

  const { data: data } = courses.data;
  const courseInfo = data.flat();
  const regCourses = courseInfo.filter(
    (el: any) => el.student_id == props.params.id
  );

  const regCoursesInfo = [];
  for (let courses of regCourses) {
    for (let info of data[0]) {
      if (info.course_code == courses.course_code) {
        info.date = courses.reg_date;
        regCoursesInfo.push(info);
      }
    }
  } */

  return (
    <>
      <Navbar id={props.params.id} />
      <div className="flex justify-center flex-grow">
        {displayCourses(Card2, props.params.id, props.params.courseCode)}
      </div>
      <div className="flex justify-center space-x-8 my-4 dark:text-white">
        <div className="flex flex-col items-center">
          <CiMap className="text-3xl" />
          <span className="text-sm mt-1">Syllabus</span>
        </div>
        <div className="flex flex-col items-center">
          <GoCommentDiscussion className="text-3xl" />
          <span className="text-sm mt-1">Discussion</span>
        </div>
        <div className="flex flex-col items-center">
          <FaRegNoteSticky className="text-3xl" />
          <span className="text-sm mt-1">Lessons</span>
        </div>
        <div className="flex flex-col items-center">
          <CiFolderOn className="text-3xl" />
          <span className="text-sm mt-1">Resources</span>
        </div>
      </div>
      <Footer />
    </>
  );
}
