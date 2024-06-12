interface coursesProps {
  props: {
    courseName: string;
    courseCode: string;
    credit: string;
    lecturer: string;
    ta: string;
  };
}

export default function Select_course({ props }: coursesProps) {
  return (
    <tbody>
      <tr className="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700">
        <td className="p-4 w-4">
          <div className="flex items-center">
            <input
              id="checkbox-table-search-1"
              type="checkbox"
              className="w-4 h-4 text-primary-600 bg-gray-100 rounded border-gray-300 focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
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
          <div className="flex items-center mr-3">{props.courseName}</div>
        </th>
        <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
          <span className="bg-primary-100 text-primary-800 text-xs font-medium px-2 py-0.5 rounded dark:bg-primary-900 dark:text-primary-300">
            {props.courseCode}
          </span>
        </td>
        <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
          <div className="flex items-center">{props.credit} </div>
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
