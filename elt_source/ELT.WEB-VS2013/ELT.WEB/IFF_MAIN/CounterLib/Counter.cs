using System;
using System.IO;

namespace CounterLib
{
	/// <summary>
	/// Counter에 대한 요약 설명입니다.
	/// </summary>
	public class Counter
	{
		private FileInfo file; 

		public Counter(string filePath)
		{
			file = new FileInfo(filePath);
		}

		public void WriteCount(string countValue)
		{
			StreamWriter sw = file.CreateText();
			sw.WriteLine(countValue);
			sw.Close();
		}

		public int ReadCount()			
		{
			StreamReader reader = file.OpenText();
			int count = int.Parse(reader.ReadLine());
			reader.Close();

			return count;
		}

		public bool Exists
		{
			get
			{
				return file.Exists;
			}
		}
	}
}
