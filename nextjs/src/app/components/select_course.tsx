import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

interface coursesProps {
  props: {
    course_name: string;
    course_code: string;
    credits: number;
    lecturer: string;
    ta: string;
  };
}

export function ButtonOrMessage(props: { count: number }) {
  let buttonOrMessage;

  if (props.count > 0) {
    buttonOrMessage = (
      <button className="flex items-center justify-center text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-primary-600 dark:hover:bg-primary-700 focus:outline-none dark:focus:ring-primary-800 mt-5 ms-5">
        Register
      </button>
    );
  } else {
    buttonOrMessage = (
      <p className="flex items-center justify-center text-white ms-5 mt-10">
        Select one or more courses to register
      </p>
    );
  }

  return <div>{buttonOrMessage}</div>;
}

export default function Select_course({
  props,
  onCheckboxClick,
}: coursesProps & {
  onCheckboxClick: (data: any, selectState: boolean) => void;
}) {
  const [isSelected, setSelectState] = useState(false);
  let [count, setCount] = useState(0);
  /*  useEffect(() => {
    console.log("render");
  }); */

  const handleCheckboxClick = () => {
    const selected = !isSelected;
    setSelectState(selected);
    setCount(count++);
    const courseData = {
      course_name: props.course_name,
      course_code: props.course_code,
      credits: props.credits,
      lecturer: props.lecturer,
      ta: props.ta,
    };
    onCheckboxClick(courseData, selected);
    ButtonOrMessage({ count });
  };
  return (
    <tbody>
      <tr className="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700">
        <td className="p-4 w-4">
          <div className="flex items-center">
            <input
              id="checkbox-table-search-1"
              type="checkbox"
              className="w-4 h-4 text-primary-600 bg-gray-100 rounded border-gray-300 focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
              onChange={handleCheckboxClick}
              checked={isSelected}
            />
            <label htmlFor="checkbox-table-search-1" className="sr-only">
              checkbox
            </label>
          </div>
        </td>
        <th
          scope="row"
          className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white"
        >
          <div className="flex items-center mr-3">{props.course_name}</div>
        </th>
        <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
          <span className="bg-primary-100 text-primary-800 text-xs font-medium px-2 py-0.5 rounded dark:bg-primary-900 dark:text-primary-300">
            {props.course_code}
          </span>
        </td>
        <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
          <div className="flex items-center">{props.credits} </div>
        </td>
        <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
          {props.lecturer}{" "}
        </td>
        <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
          {props.ta}
        </td>
      </tr>
    </tbody>
  );
}
